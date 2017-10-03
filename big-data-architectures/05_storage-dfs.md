# Storage: Distributed File System

La capacità e la velocità di trasferimento dei dispositivi di storage sono aumentate molto negli ultimi anni.
Tuttavia, questi miglioramenti non sono sufficienti a far fronte agli attuali scenari data-intensive.
Pertanto, vi è la necessità di sviluppare sistemi che permettano di scalare orizzontalmente lo strato di storage.

Un sistema di storage deve dunque essere: scalabile, fault-tolerant e altamente disponibile.

Le tecnologie di data storage sono:
* **Distributed File System (DFS):** file system distribuito per la gestione di file di grandi dimensioni.
Le tecnologie più diffuse sono: *Google File System (GFS), Hadoop Distributed File System (HDFS), FlatDS, Alluxio, Ceph*.

* **NoSQL Database (Datastore):** data model non relazionale basato su aggregati (key-value, column-family, document), grafi e time-series (on top a tecnologie NoSQL).
Le tecnologie più diffuse sono: *Dynamo, BigTable, MongoDB, InfluDB*.

* **NewSQL Database (NewSQL DB):** aggiungono scalabilità orizzontale e fault-tolerance al modello relazionale
Le tecnologie più diffuse sono: *Google Spanner, VoltDB*.


## GFS
Google File System (GFS) è un distributed file system sviluppato per applicazioni di batch processing e noto per la sua semplicità e alto throughput. Utilizzato in molte applicazioni di Google.

Le assunzioni che ne hanno guidato lo sviluppo sono:
* i fallimenti sono la norma
* pochi file di grandissime dimensioni (multi-GB)
* tante operazioni Read streaming (poche Read random)
* le operazioni Write (alta concorrenza) sono di tipo append
* l'alto throughput è più importante della bassa latenza

Le caratteristiche principali sono:
* sistema AP
* eventual consistency
* atomicità delle Write su namespace e delle Append su file
* file divisi trasparentemente in chunk (64MB o 128MB), ognuno dei quali è memorizzato come file plain in almeno un ChunkServer.
* ogni chunk è diviso in blocchi (64KB); ogni blocco ha un checksum (32B) in-memory
* il checksum di un chunk è verificato ad ogni Read
* control plane disaccoppiato dal data plane (interazione Client/Master solo per metadati, interazione Client/ChunkServer solo per i dati, interazione ChunkServer/ChunkServer per flusso dati di replicazione (meccanismo chunk lease))
* i file seguono il pattern write-once/read-many-times, garantendo un efficiente append atomico at-least-once
* fault-tolerance mediante replicazione dei chunk
* ogni chunk ha almeno 3 repliche secondo schema primary-backup
* ogni chunk è replicato sia all'interno di uno specifico rack, che su rack separati
* caching dei metadati, ma non dei dati
* architettura Master/Slave:
  * Master: non replicato, gestisce in-memory i metadati (namespace di file/chunk, mapping file/chunk, posizione chunk), gestisce le operazioni sui chunk (creazione, replicazione, rimozione, load balancing), logging persistente delle operazioni critiche come checkpointing per fast-recovery, garbage collection (ai file da cancellare viene dato un nome nascosto e associato un countdown per la definitiva rimozione), locking sul namespace, reconciliation di chunk replicati mediante version number, heartbeating con i ChunkServer
  * ChunkServer: memorizza i chunk
  * Client: richiede i metadati al Master, caching dei metadati, richiede i dati ai ChunkServer,
* alto throughput
* alta latenza
* non esiste una struttura rappresentante la directory
* il directory tree è incapsulato nel namespace (il nome del file è il suo pathname)
* il Master garantisce sempre il grado di replicazione dei chunk. Quando un nodo va giù i suoi chunk vengono replicati su altri nodi.

Considerazioni:
* i chunk sono fissati a dimensioni grandi per
(i) ridurre la dimensione dei metadati nel Master
(ii) ridurre l'interazione tra Client e Master
(iii) aumentare l'utilizzo di connessioni TCP tra Client e ChunkServer
Tuttavia, chunk di grandi dimensioni rendono sconveniente avere file di piccole dimensioni
* la gestione in-memory dei metadati rende efficiente la gestione del file system, ma il numero di chunk è limitato dalla memoria del Master.
* il Master rappresenta un single-point-of-failure e un bottleneck. Questi limiti vengono contrastati da
(i) repliche del Master per accesso read-only
(ii) interazione Client/Master solo per i metadati
(iii) caching dei metadati nel Client
(iv) chunk di grandi dimensioni
(v) coordinamento delle repliche delegato alla replica primaria
* adatto per applicazioni batch ma non per applicazioni real-time
* il meccanismo di garbage collection permette il recupero di dati cancellati entro un certo limite temporale


## Colossus
Colossus (anche detto GFS2) è la seconda versione di GFS.

Estende GFS, prevedendo:
* distribuzione del Master
* sharding dei metadati
* encoding Reed-Solomon per autocorrezione degli errori
* chunk da 1MB per supportare file di piccole dimensioni
* supporto per applicazioni real-time


## FDS
Il Flat Datacenter Storage (FDS) è una classe di DFS in cui il datacenter è visto come un insieme omogeneo di risorse di storage (cioè senza distinguere dischi locali e dischi remoti).

Le assunzioni che ne hanno guidato lo sviluppo sono:
* la massimizzazione della data-locality è complessa
* la rete all'interno di un datacenter è molto veloce, anche tra rack diversi

Le caratteristiche principali sono:
* dischi locali e remoti indistinguibili
* sharding dei metadati
* load balancing su tutti i dischi
* accesso alle risorse di storage con uguale throughput per ogni nodo
* file memorizzati come BLOB e divisi in tract (8MB)
* i Tract sono replicati su TractServer
* ogni disco è gestito da un TractServer
* il MetadataServer mantiene la Tract Locator Table (TLT) indicizzata da Locator (i.e., Tract_Locator = Hash(BLOB_GUID)+TractNumber mod TLT_Lenght). Il TractLocator permete di individuare i dischi in cui è replicato il Tract richiesto.
* I/O: Read/Write atomiche, ma senza garanzia di ordinamento; il Client è responsabile di mantenere la replicazione, ovvero per le Read viene scelto un TractServer random mentre la Write scrive su tutti i TractServer che replicano il Tract interessato.
* failure-detection: basata su herthbeat dei TractServer al MetadataServer
* failure-recovery: basato su sostituzione del TractServer fallito all'interno della TLT
* API: asincrona


## Alluxio
Alluxio (precedentemente chiamato Tachyon) è un DFS in-memory noto per l'alto throughput in Read/Write e l'utilizzo della tecnica lineage per la gestione della memoria.

Le principali caratteristiche sono:
* DFS in-memory
* architettura Master/Slave
  * Master: replicato ed eletto mediante Quorum con Zookeeper, responsabile della gestione dei metadati, delle informazioni sui Track Lineage e del recovery basato su checkpointing, status check degli Slave
  * Slave: gestione delle risorse del nodo, herthbeating al Master e gestione dei file in-memory.
* alto throughput per Read/Write
* efficienza e fault-tolerance garantite dalla tecnica di lineage
* si interpone tra lo strato di Framework e lo strato DFS
* si sviluppa su due livelli:
  * Lineage Layer: mantiene le dipendenze delle modifiche ai file e ricalcola il risultato di queste dipendenze solo a seguito di un fallimento.
  * Persistence Layer: rende persistente il checkpoint dei dati (dando maggiore priorità a quelli più acceduti, ed escludendo quelli temporanei).


## HDFS
Hadoop Distributed File System (HDFS) è un DFS sviluppato come versione open-source del Google File System.
È un de-facto standard per il data storage in applicazioni batch.

Le caratteristiche principali (praticamente identiche a quelle di GFS) sono:
* adatto al processamento di file di grandi dimensioni
* pattern write-once, read-many-times
* progettato per commodity HW
* portabile
* un cluster HDFS è costituito da nodi:
  * NameNode: master, responsabile del namespace, dei metadati e del mapping blocco-DataNode.
  * DataNode: worker, memorizza i blocchi dei file.
* non tollerante al guasto del NameNode.
* un file è partizionato in blocchi da 128MB, distribuiti e replicati su un insieme di DataNode
* di ogni file è possibile specificare il grado di replicazione
* disponibile una WebUI
* snapshooting molto efficiente

HDFS non è adatto per:
(i) applicazioni real-time, in quanto è progettato per massimizzare il throughput e non per minimizzare la latenza,
(ii) gestione di molti file di piccole dimensioni,
(iii) gestione di scritture concorrenti.
