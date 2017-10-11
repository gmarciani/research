# Storage: Distributed File System
L'aumento di capacità e velocità di trasferimento dei dispositivi di storage non sono sufficienti a far fronte agli attuali scenari data-intensive.

Vi è dunque la necessità di sviluppare sistemi di storage scalabili, fault-tolerant e disponibili.

Le tecnologie di data storage sono:

* **Distributed File System (DFS):** file system distribuito per la gestione di file di grandi dimensioni.
Le tecnologie più diffuse sono: *Google File System (GFS), Hadoop Distributed File System (HDFS), FlatDS, Alluxio, Ceph*.

* **NoSQL Database (Datastore):** data model non relazionale basato su aggregati (key-value, column-family, document), grafi, search database e time-series database.
Le tecnologie più diffuse sono: *Dynamo, BigTable, MongoDB, InfluxDB*.

* **NewSQL Database (NewSQL DB):** aggiungono scalabilità orizzontale e fault-tolerance al modello relazionale.
Le tecnologie più diffuse sono: *Google Spanner, VoltDB*.

---

## GFS
Google File System (GFS) è un DFS sviluppato per applicazioni di batch processing e noto per la sua semplicità e alto throughput. Utilizzato in molte applicazioni di Google.

Le assunzioni che ne hanno guidato lo sviluppo sono:
* i fallimenti sono la norma
* pochi file di grandissime dimensioni (multi-GB)
* tante operazioni Read streaming (poche Read random)
* le operazioni Write (alta concorrenza) sono di tipo append
* alto throughput è più importante della bassa latenza

Le caratteristiche principali sono:

* sistema AP: eventual consistency.

* architettura *master-slave*:
  * **Master (M):** non replicato, gestisce in-memory i metadati (namespace di file/chunk, mapping file/chunk, mapping chunk/ChunkServer), gestisce le operazioni sui chunk (creazione, replicazione, rimozione, load balancing), logging persistente delle operazioni critiche come checkpointing per fast-recovery, garbage collection (ai file da cancellare viene dato un nome nascosto e associato un countdown per la definitiva rimozione), locking sul namespace, reconciliation di chunk replicati mediante version number, heartbeating con i ChunkServer
  * **ChunkServer (CS):** ogni nodo ha un CS, il quale è responsabile della memorizzazione dei chunk sul nodo.
  * **Client (C):** richiede i metadati al M, caching dei metadati, richiede i dati ai CS.

* disaccoppiamento control/data plane:
  * interazione C/M solo per metadati.
  * interazione C/CS solo per i dati, interazione CS/CS per flusso dati di replicazione (meccanismo chunk lease).
  * caching dei metadati, ma non dei dati

* sharding dei dati:
  * file divisi in chunk (64MB o 128MB), ognuno dei quali è memorizzato in almeno un ChunkServer.
  * ogni chunk è diviso in blocchi (64KB); ogni blocco ha un checksum (32B) in-memory, verificato ad ogni Read.

* fault-tolerance: replicazione dei chunk (almeno 3 repliche primary-backup) inter/intra rack garantita dal Master (quando un nodo va giù i suoi chunk vengono replicati su altri nodi).

* alto throughput, ma alta latenza.

* I/O:
  * non esiste una struttura rappresentante la directory: il directory tree è incapsulato nel namespace (il nome del file è il suo pathname).
  * atomicità delle Write su namespace e delle Append su file.
  * pattern write-once, read-many-times, garantendo efficiente append atomico at-least-once.

Considerazioni:

* i chunk hanno grande dimensione (64/128MB):
  * riduzione dei metadati nel Master.
  * riduzione interazione Client/Master.
  * aumento utilizzo di connessioni TCP Client/ChunkServer
  * sconveniente avere tanti file di piccole dimensioni

* la gestione in-memory dei metadati rende efficiente la gestione del file system, ma il numero di chunk è limitato dalla memoria del Master.

* il Master rappresenta un single-point-of-failure e un bottleneck. Questi limiti vengono contrastati da
  * repliche del Master per accesso read-only
  * interazione Client/Master solo per i metadati
  * caching dei metadati nel Client
  * chunk di grandi dimensioni
  * coordinamento delle repliche delegato alla replica primaria

* adatto per applicazioni batch ma non per applicazioni real-time

---

## Colossus
Colossus (anche detto GFS2) è un DFS sviluppato come seconda versione di GFS.

Estende GFS, prevedendo:
* distribuzione del Master.
* sharding dei metadati.
* encoding Reed-Solomon per autocorrezione degli errori.
* chunk da 1MB per supportare file di piccole dimensioni.
* supporto per applicazioni real-time.

---

## HDFS
Hadoop Distributed File System (HDFS) è un DFS sviluppato come versione open-source di GFS.

È il de-facto standard per il data storage in applicazioni batch.

Le caratteristiche principali e le considerazioni sono simili a GFS. A queste si aggiungono:

* un cluster HDFS è costituito da nodi:
  * **NameNode (NN):** master, responsabile del namespace, dei metadati e del mapping blocco-DataNode.
  * **DataNode (DN):** worker, esegue operazioni R/W sui propri blocchi.

* sharding:
  * un file è partizionato in *blocchi da 128MB*
  * ogni blocco è replicati su un insieme di DataNode
  * di ogni file è possibile specificare il grado di replicazione

* fault-tolerance:
  * meccanismo di snapshooting molto efficiente.
  * non tollerante al guasto del NameNode.

* progettato per commodity HW
* portabile

* disponibile una WebUI

---

## FDS
Il Flat Datacenter Storage (FDS) è una classe di DFS in cui il datacenter è visto come un insieme omogeneo di risorse di storage (cioè senza distinguere dischi locali e dischi remoti).

Le assunzioni che ne hanno guidato lo sviluppo sono:

* la massimizzazione della data-locality è troppo complessa.
* la rete all'interno di un datacenter è molto veloce, anche tra rack diversi.

Le caratteristiche principali sono:

* architettura *master-slave*:
  * **MetadataServer (MS):** mantiene la *Tract Locator Table (TLT)* indicizzata da *TractLocator* (i.e., Tract_Locator = Hash(BLOB_GUID)+TractNumber mod TLT_Lenght), la quale permette di individuare i dischi in cui è replicato il Tract richiesto.
  * **TractServer (TS):** ogni disco è gestito da un TS.

* sharding:
  * sharding dei metadati.
  * file memorizzati come BLOB e divisi in *tract (8MB)* replicati sui TS.

* fault-tolerance:
  * failure-detection: basata su herthbeat dei TractServer al MetadataServer.
  * failure-recovery: basato su sostituzione del TractServer fallito all'interno della TLT.

* visione flat dei dischi del datacenter:
  * dischi locali e remoti indistinguibili.
  * load balancing su tutti i dischi.
  * accesso alle risorse di storage con uguale throughput per ogni nodo.

* I/O:
  * Read/Write atomiche, ma senza garanzia di ordinamento.
  * il Client è responsabile della replicazione: per le Read viene scelto un TractServer random, le Write scrive su tutti i TractServer che replicano il Tract interessato.
  * API: asincrona

---

## Alluxio
Alluxio (precedentemente chiamato Tachyon) è un DFS in-memory noto per l'alto throughput in Read/Write e l'utilizzo della tecnica lineage per la gestione della memoria.

Le principali caratteristiche sono:
* DFS in-memory.

* architettura *master-slave* interposta tra strato DFS e strato Framework:
  * **Master (M):** replicato ed eletto mediante Quorum con Zookeeper, responsabile della gestione dei metadati, delle informazioni sui Track Lineage e del recovery basato su checkpointing, status check degli Slave.
  * **Slave (S):** gestione delle risorse del nodo, herthbeating al M e gestione dei file in-memory.

* fault-tolerance:
  * tecnica di lineage.
  * Lineage Layer: mantiene le dipendenze delle modifiche ai file e ricalcola il risultato di queste dipendenze solo a seguito di un fallimento.
  * Persistence Layer: rende persistente il checkpoint dei dati (dando maggiore priorità a quelli più acceduti, ed escludendo quelli temporanei).

* I/O:
  * alto throughput per Read/Write.
