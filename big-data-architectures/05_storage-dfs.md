# Storage: Distributed File System
L'aumento di capacità e velocità di trasferimento dei dispositivi di storage non sono sufficienti a far fronte agli attuali scenari data-intensive.

Vi è dunque la necessità di sviluppare sistemi di storage scalabili, disponibili e fault-tolerant.

Le tecnologie di data storage sono:

* **Distributed File System (DFS):** file system distribuito per la gestione di file di grandi dimensioni.
Le tecnologie più diffuse sono: *Google File System (GFS), Hadoop Distributed File System (HDFS), FlatDS, Alluxio, Ceph*.

* **NoSQL Database (Datastore):** data model non relazionale basato su aggregati (key-value, column-family, document), grafi.
Le tecnologie più diffuse sono: *DynamoDB, BigTable, MongoDB, InfluxDB*.

* **NewSQL Database (NewSQL DB):** aggiungono scalabilità orizzontale e fault-tolerance al modello relazionale.
Le tecnologie più diffuse sono: *Google Spanner, VoltDB*.

* **Search Database (SDB):** estrazione di caratteristiche complesse dai dati in modo semplice, efficace e scalabile.
Le tecnologie più diffuse sono: *Elasticsearch, Solr*.

* **Time-Series Database (TSDB):** analisi di grandi quantità di serie temporali in modo semplice, efficace e scalabile.
Le tecnologie più diffuse sono: *InfluxDB, KairosDB*.

---

## GFS
Google File System (GFS) è un *distributed file system closed source* sviluppato per applicazioni di batch processing e noto per la sua semplicità e alto throughput.

Utilizzato in molte applicazioni di Google.

Le assunzioni che ne hanno guidato lo sviluppo sono:

* i *fallimenti* sono la norma.
* *pochi file di grandissime dimensioni*.
* tante operazioni *Read streaming* (poche Read random).
* le operazioni Write (alta concorrenza) sono di tipo *Write Append*.
* *alto throughput* è più importante della bassa latenza.

Le caratteristiche principali sono:

* **sistema AP**: alta disponibilità e *consistenza eventuale*.

* **architettura master-slave:**
  * **Master (M):** non replicato, gestisce in-memory i metadati (namespace di file/chunk, mapping file/chunk, mapping chunk/ChunkServer), gestisce le operazioni sui chunk (creazione, replicazione, rimozione, load balancing), logging persistente delle operazioni critiche come checkpointing per fast-recovery, garbage collection (ai file da cancellare viene dato un nome nascosto e associato un countdown per la definitiva rimozione), locking sul namespace, reconciliation di chunk replicati mediante version number, heartbeating con i ChunkServer
  * **ChunkServer (CS):** ogni nodo ha un CS, il quale è responsabile della memorizzazione dei chunk sul nodo.
  * **Client (C):** richiede i metadati al M, caching dei metadati, richiede i dati ai CS.

* **disaccoppiamento control/data plane:**
  * C e M interagiscono solo per metadati.
  * C e CS interagiscono solo per i dati.
  * CS e CS interagiscono solo per il flusso dati di replicazione (meccanismo chunk lease).
  * caching dei metadati, ma non dei dati

* **sharding:**
  * file divisi in **chunk** (64MB o 128MB), ognuno dei quali è memorizzato in almeno un CS.
  * ogni chunk è diviso in **block** (64KB); ognuno dei quali ha un **checksum in-memory** (32B), verificato ad ogni Read.

* **fault-tolerance:** M garantisce sempre la replicazione dei chunk (almeno 3 repliche primary-backup) inter/intra rack; quando un nodo va giù i suoi chunk vengono replicati su altri nodi.

* **I/O:**
  * il *directory tree* è incapsulato nel namespace, ovvero il nome del file è il suo pathname.
  * *atomicità delle Write (Append)*.
  * *pattern write-once-read-many-times*, garantendo efficiente *append atomico at-least-once*.

Considerazioni:

* alto throughput, ma alta latenza, pertanto è adatto per applicazioni batch ma non per applicazioni real-time.

* la gestione in-memory dei metadati rende efficiente la gestione del file system, ma il numero di chunk è limitato dalla memoria del Master.

* i chunk hanno grande dimensione (64/128MB), ne consegue:
  * riduzione dei metadati nel Master.
  * riduzione interazione Client/Master.
  * aumento utilizzo di connessioni TCP tra C e CS.
  * sconveniente avere tanti file di piccole dimensioni.

* il Master rappresenta un single-point-of-failure e un bottleneck. Questi limiti vengono contrastati da
  * repliche del Master per accesso read-only.
  * interazione Client/Master solo per i metadati.
  * caching dei metadati nel Client.
  * chunk di grandi dimensioni.
  * coordinamento delle repliche delegato alla replica primaria.

![GFS, architettura](img/data-storage-gfs-architecture.png "GFS, architettura")

---

## Colossus
Colossus (anche detto GFS2) è un *distributed file system closed source* sviluppato come seconda versione di GFS.

L'obiettivo che ne ha guidato lo sviluppo è il *supporto per applicazioni real-time*.

Estende GFS, prevedendo:

* **distribuzione del Master**.
* **sharding dei metadati**.
* **encoding Reed-Solomon** per autocorrezione degli errori.
* **chunk piccoli** (1MB) per supportare file di piccole dimensioni.

---

## HDFS
Hadoop Distributed File System (HDFS) è un *distributed file system open source* sviluppato come versione open-source di GFS e affermatosi come *de-facto standard* per il data storage in *applicazioni batch*.

Le caratteristiche principali e le considerazioni sono simili a GFS. Riportiamo dunque solo alcuni dettagli aggiuntivi:

* **architettura master-slave:** il master è chiamato **NameNode (NN)**, lo slave è chiamato **DataNode (DN)**.

* **sharding:** ogni file è partizionato in **block (128MB)** replicati su un insieme di DataNode, secondo il *grado di replicazione specifico per il file*.

* **fault-tolerance:** prevede uno *snapshooting molto efficiente*, ma è *non tollerante al guasto del NameNode*.

* progettato per commodity HW
* portabile
* disponibile una WebUI

![HDFS, architettura](img/data-storage-hdfs-architecture.png "HDFS, architettura")

---

## FDS
Il Flat Datacenter Storage (FDS) è una classe di DFS in cui il datacenter è visto come un *insieme omogeneo di risorse di storage*, ovvero senza distinzione tra dischi locali e remoti.

Le assunzioni che ne hanno guidato lo sviluppo sono:

* *la massimizzazione della data-locality è troppo complessa*.
* *la rete inter rack è sufficientemente veloce*.

Le caratteristiche principali sono:

* **architettura master-slave:**
  * **MetadataServer (MS):** mantiene la *Tract Locator Table (TLT)* indicizzata da *TractLocator* (i.e., Tract_Locator = Hash(BLOB_GUID)+TractNumber mod TLT_Lenght), la quale permette di individuare i dischi in cui è replicato il Tract richiesto.
  * **TractServer (TS):** ogni disco è gestito da un TS.

* **sharding:**
  * ogni file è memorizzato come un *BLOB** partizionato in **Tract (8MB)** replicati sui TractServer.
  * prevede lo *sharding dei metadati*.

* **fault-tolerance:** la failure-detection avviene mediante *hearthbeating* dei TS su MS; la failure-recovery avviene *sostituendo nella TLT* il TS guasto.

* **flat datacenter**:
  * dischi locali e remoti indistinguibili.
  * load balancing su tutti i dischi.
  * accesso alle risorse di storage con uguale throughput per ogni nodo.

* **I/O:**
  * il Client è responsabile della replicazione: per le Read viene scelto un TractServer random, le Write scrive su tutti i TractServer che replicano il Tract interessato.
  * Read/Write atomiche, ma senza garanzia di ordinamento.
  * API: asincrona

![FDS, architettura](img/data-storage-fds-architecture.png "FDS, architettura")

---

## Alluxio
Alluxio è un *distributed file system in-memory* noto per l'alto throughput, l'utilizzo della tecnica lineage per la gestione della memoria.

Si posiziona *tra lo strato DFS e i framework*.

Le principali caratteristiche sono:

* **in-memory data storage:** i file sono mantenuti in memoria.

* **alto throughput**

* **architettura master-slave:**
  * **Master (M):** replicato ed eletto mediante quorum con Zookeeper, responsabile della gestione dei metadati, delle informazioni sui Track Lineage e del recovery basato su checkpointing, status check degli Slave.
  * **Slave (S):** gestione delle risorse del nodo, herthbeating al M e gestione dei file in-memory.

* **fault-tolerance:**
  * la **tecnica lineage** permette di mantenere le dipendenze delle modifiche ai file, ricostruendoli in caso di fallimento.
  * il *checkpointing persistente dei dati* viene eseguito dando *maggiore priorità ai file maggiormente acceduti*.

![Alluxio, architettura](img/data-storage-alluxio-architecture.png "Alluxio, architettura")
