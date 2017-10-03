# Memoria
La differenza tra un file ed un db sta nel fatto che il file system decide la struttura dei file, nei db è la definizione della struttura ad essere data dall'utente.
Per la memorizzazione dobbiamo fare scale out, non scale in.
Si utilizza tanto hardware commodity->hardware soggetto a fallimenti-> necessaria fault tolerance.
I database NoSQL possono essere: chiave-valore, column-family (dati organizzati a colonne), document-base (tipicamente formato json), time-series (ottimizzano studi statistici su base temporale), graph store.
Dietro a VoltDB ci sta Stonebraker (premio Turing 2016, inventore del modello ER)


# File System distribuiti
gestione trasparente di file memorizzati su più nodi.
GFS nasce per batch processing.
Ci sono anche Storage in-memory per massimizzare il throughput, come ad esempio Alluxio.
Obiettivi:
- in-memory (Alluxio)
- hpc: (Ceph)
- fault.tolerance ()


## Google File System
* Architetture master-slave
* disaccoppiamento tra dati e metadati
* master centralizzato -> bottleneck e spof.
* grandi chunk
* no caching dei dati

GFS è implementato in user-space così da poter funzionare su nodi eterogenee.
GFS ottimizza l'operazione atomica di append.
*È strano che GFS non abbia caching dei dati. Questo è perchè ....?*
GFS separa dati ed descrittori dei dati: il GFS master indicizza i chunk, i GFS slave memorizzano i chuncks
Le informazioni di replicazione die chhunk sono nei descrittori dei file.
GFS master è singolo: single point of failure, bottleneck, l'indicizzazione è limitata perchè la memoria del master è finita.
La dimensione della memoria del mGFS master determina la massima capacità del GFS.
La dimensione dei chunk è abbastanza elevata (64MB 128MB), questo serve a ridurre le interazioni tra clinet e master così da ridurre l'overhead di comunicazione.
Il grado di replicazione è 3 o maggiore di 3, replicazione primary backup.
Primary backup: scrittura sincrona su copia primaria, poi scrittura asincrona sulle repliche.
Replicazione di grado 3 permette tolleranza ad 1 solo guasto.
Replicazione di grado 5 permette tolleranza a 2 guasti.
I nodi di uno stesso rack sono collegati allo stesso switch, quindi comunicano in modo efficiente (ordine di 10 Gbps)
Se utilizzo nodi appartenenti a rack differenti sfrutto la banda aggregata (ordine di 20 Gpbs) e aumento la fault tolerance del data center.
*Il checksum dei chucnk viene memorizzato dal GFS master?*
GFS master rappresenta il namespace con una lookup table: il path funge da chiave hash per recuperare l'indirizzo del nodo.
Read lock su cartelle intermedie. Write lock su file.
Il GFS master utilizza herthbeat e analisi dello stato dei chunk server così da poter fare load balancing, replication recovery.
La replicazione in GFS è una operazione molto costosa.
*cosa sono i file hot spot?*
La garbage collection si fa in questo modo (slide 16) per rendere reversibile nel breve periodo una eventuale rimozione involontaria.
Per ogni aggiornamento del chucnk viene incrementato  il suoi numero di versione così da poter fare stale replica detection. Bisogna infatti individuare le repliche obsolete.
Le repliche obsolete sono trattate come fallimenti della replicazione. Quindi una replica obsolete viene rimossa e sovrascritta.
Snapshot: copiare tutto il contenuto di una cartella.
Lo snapshot è implementato molto efficientemente: bisogna solo modificare i metadati.
La tecnica di copy-on-write rende efficiente lo snapshot.

RIPASSARE LA CONSISTENZA (SDCC)

Soluzione per centralizzazione del master: copie fredde, distribuzione del GFS master (Colossus, aka GFS2).


## Flat datacenter Storage
* architettura distribuita di tipo flat
* il cliet deve replicare manualmente i dati
* i metadati contengono locators e non data location.

I dati sono memorizzari in BLOB, indicizzati con GUID a 128bit.
API non bloccanti.
Il client replica (manualmente??) sui nodi.
Il client ha necessità di comunicare con il master solo quando deve aggiornare la track table.
Il GUID del file è determinato da caratteristiche statiche del file.


## Other: Alluxio (aka Tackyon)
aggiungo un livello di indirezione: il livello di persistenza può anche essere implementat da un file system distribuito.
lineage layer: memorizzare la dipendenza tra task che modificano i dati e il file originario. in caso di falimento, viene ricomputata la modifica.


## Hadoop Distributed File System
Implementazione open-source di GFS.
de-facto standard per batch processing.
patterns: write-once, read-many-times
Pensato per hardware commodity -> i fallimenti accadono.
Un chunk è chiamato block, o shard.
Master è chiamato NameNode
Slave èchiamato DataNode
TRa NameNode e DataNode ci sta una comunicazione periodica instanziata dal NameNode per sapere lo stato di salute dei DataNode
Il NameNode è il bottleneck e spof della soluzione.
Possono però essere impostati dei NameNode ombra.
I DataNode sono responsabili di replicare i chunk.
Periodicamente viene eseguita garbage collection sui dataNode. Se ci sono stati dei fallimenti delle operazioni


## SQL DB
In un RDBMS i dati vengono memorizzati su file, riga per riga. PEr ottimizzare l'accesso vengono imposati degli indici.
Si accede con un offset a tutti i campi della riga.
Essendo memorizzati per righe, è lento l'accesso per colonne, perchè il disco deve ruotare per accedere a settori differenti.
Gli indici cambiano la localizzazione dei blocchi dati, per ottimizzarne l'acesso.
