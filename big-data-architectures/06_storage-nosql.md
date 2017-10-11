# Storage: NoSQL Database


## RDBMS
I Relational Data Base Management Systems (RDBMS) sono i sistemi tradizionali di data storage relazionale.

I vantaggi principali sono:

* garanzia ACID
* linguaggio SQL
* data model relazionale (tabelle, righe, colonne) molto intuitivo
* schemi relazionali modificabili senza downtime
* integrità relazionale
* facilità di comprensione del modello relazionale
* supporto per applicazioni OLTP (OnLine Transaction Processing)
* DBMS stabili e standardizzati

Gli svantaggi principali sono:

* non progettati per essere distribuiti
* non scalabili orizzontalmente
* supporto limitato per la definizione di strutture dati complesse
* necessaria conoscenza completa del DB per formulare query
* DBMS proprietari costosi
* supporto limitato a data integration tra DBMS diversi
* limiti sulla dimensione dei campi

Le moderne applicazioni web comportano:

* massive data
* spikes di traffico
* alto rate R/W
* modifiche ai data schema, supposti flesibili

Una possibile soluzione per gli RDBMS è di prevedere:

* *replicazione:* un'architettura master-slave in cui il Master regola la replicazione sugli Slave permetterebbe di scalare le Read, ma non le Write.
* *sharding:* il partizionamento orizzontale dei dati su più nodi (ad esempio, mediante consistent hashing) permetterebbe di scalare le Read e le Write, ma eliminerebbe le garanzie ACID.

Pertanto, scalare i RDBMS è costoso ed inefficiente.


## NoSQL Datastore
I datastore NoSQL (Not-Only-SQL) sono una classe di tecnologie di data storage che si propone come alternativa ai tradizionali RDBMS, per ovviare ai limiti di questi ultimi in termini di scalabilità orizzontale. Il principio fondante di questi sistemi è evitare complessità non strettamente necessarie, a favore delle performance.

Le caratteristiche principali sono:

* garanzia BASE
* scalabilità orizzontale, grazie a sharding e replicazione
* distribuzione geografica
* schemi flessibili
* alta disponibilità grazie alla replicazione dei dati su più nodi
* fault-tolerance grazie alla replicazione
* API molto semplice

Il data model NoSQL possono essere:

* **aggregate-oriented:** i dati sono rappresentati come aggregati, ovvero strutture dati complesse (record con field semplici, array e record innestati) tali che, all'interno di uno stesso aggregato, vi è garanzia ACID. Tipicamente non vi è garanzia ACID inter-aggregato.
I tipi di aggregato sono:

  * **key-value:** i dati sono rappresentati come una collezione di coppie chiave-valore, in cui il valore può essere a sua volta un aggregato (tra cui anche array e map) e la struttura è opaca (query solo sulle chiavi, non sui campi dell'aggregato). I dati sono memorizzati come un BLOB e acceduti mediante lookup sulla chiave. Alcuni datastore supportano l'ordinamento delle chiavi e lo store in-memory dei dati.
  Alcuni datastore supportano anche (i) ordinamento delle chiavi, (ii) store in-memory dei dati e (iii) query con full-text search sul contenuto del valore.
  I modelli di consistenza adottati sono: consistenza finale (AP) e consistenza linearizzabile (CP).
  Gli esempi applicativi più diffusi sono: storing delle informazioni di sessione, profili utente, preferenze utente e shopping cart.
  I datastore più diffusi sono: *DynamoDB, Redis, Memcached, RiakKV, Voldemort, LevelDB, BerkeleyDB*.

  * **column-family:** i dati sono rappresentati come una collezione di coppie chiave-valore, in cui il valore è una collezione di attributi (colonne) con struttura visibile e organizzati in column-family. Una colonna è una collezione di attributi dello stesso tipo. Una column-family è una collezione di colonne spesso accedute contemporaneamente.
  Le caratteristiche principali sono:
  * il data model è una mappa a due livelli: [rowKey->aggregate] e ogni aggregate è un gruppo di [columnKey->value].
  * schemi flessibili: ogni riga può avere colonne diverse
  * i dati sono memorizzati column-oriented
  * i dati sono navigati sia column-oriented che row-oriented
  * colonne memorizzate in settori contigui del disco per minimizzare la latenza di I/O.
  * colonne organizzate in column-family per raggruppare le colonne frequentemente accedute insieme
  * sharding di righe e colonne su più nodi

  Gli esempi applicativi più diffusi sono: applicazioni data-intensive read-mostly in cui le query riguardano aggregazione e operazioni complesse su poche colonne.
  I datastore più diffusi sono: *BigTable, HBase, Cassandra, HyperTable, Accumulo, Amazon Redshift*.

  * **document:** i dati sono rappresentati come una collezione di coppie chiave-documento, in cui il documento è un aggregato strutturato (eventualmente innestato) con struttura visibile (sono possibili query sui campi dell'aggregato).

  Le caratteristiche principali sono:

    * aggregato con struttura visibile
    * schemi flessibili
    * documenti codificati con formati standard (e.g. XML, JSON, YAML)
    * indexing dei dati basato sul contenuto dell'aggregato
    * API CRUD uniformi, ma non standardizzate
    * operazione di Update comporta sempre la sostituzione dell'intero documento e non solo la modifica di campi specifici

  Possiamo dunque dire che
  (i) è simile ad un datastore key-value, avente però come valore un aggregato con struttura visibile e interrogabile;
  (ii) è simile ad un datastore column-family, avente però come valore un aggregato con schemi flessibili.

  Gli esempi applicativi più diffusi sono: applicazioni data-intensive operanti su dati semi-strutturati e sparsi.
  I datastore più diffusi sono: *MongoDB, CouchDB, Couchbase, RavenDB*.

* **graph-oriented:** i dati sono rappresentati come un grafo, in cui
(i) i nodi sono caratterizzati da un ID e da una collezione di coppie chiave-valore e
(ii) gli archi sono indiretti o diretti e caratterizzati da una collezione di coppie chiave-valore.
Questi datastore tendono a fornire garanzie ACID.
Di contro, lo *sharding e la scalabilità orizzontale sono difficoltosi*, in quanto è difficile partizionare dati fortemente correlati ed attraversare una struttura partizionata su più nodi.

Gli esempi applicativi più diffusi sono: applicazioni di social networks analysis, pattern recognition e reccomendation systems.
I datastore più diffusi sono: *Neo4j, OrientDB, InfiniteGraph, AllegroGraph e HyperGraphDB*.


## Performance
Non è stato ancora stabilito un benchmark standard per la valutazione delle performance dei NoSQL datastore.
Un primo tentativo è *Yahoo! Cloud Serving Benchmark (YCSB)*, ovvero un generatore di workload open-source.
In ogni caso, datastore distinti rispondono a requisiti distinti, pertanto non è possibile individuare una soluzione unica per tutti i casi.


## Persistenza poliglotta
Con il termine *peristenza poliglotta* si intende un'architettura in cui lo strato di data storage è implementato da DB e datastore differenti.
Ogni classe di datastore è infatti progettata per rispondere a requisiti diversi.
In particolare, tecnologie diverse rispondono diversamente al *trade-off individuato dal teorema CAP*.

![CAP Trade-off for NoSQL Datastore](img/nosql-datastore-cap-tradeoff.jpg "CAP Trade-off for NoSQL Datastore")

Pertanto, sistemi in cui il data storage è implemetato da una singola tecnologia possono risultare inefficienti.

Ad esempio, un'applicazione di e-commerce può implementare lo strato di data storage nel seguente modo:

* gestione dello shopping cart e della sessione utente basata su key-value datastore;
* gestione degli ordini basata su document datastore;
* gestione dell'inventario basata su RDBMS;
* gestione delle relazioni tra utenti basata su graph datastore.

---

## DynamoDB
Amazon DynamoDB è un *key-value datastore* sviluppato da Amazon e noto per (i) alta disponibilità e (ii) scalabilità (iii) garanzie SLA stringenti.
È parte integrante del portfolio AWS.

Le caratteristiche principali sono:

* sistema AP
* architettura  *P2P con membership gossip-based*
* sharding basato su *consistent hashing*:
  * ogni nodo fisico può rappresentare più nodi logici dell'anello
  * distribuzione del carico in funzione delle risorse del nodo fisico
  * grado di replicazione configurabile

* alta disponibilità:
  * i conflitti non sono prevenuti, ma risolti quando accadono dall'applicazione o datastore (last-write wins) durante operazioni Read.
  * operazioni Read/Write gestite mediante sloppy quorum in cui, se il quorum non può essere raggiunto a causa del partizionamento della rete, si creano delle repliche transitorie mediante la prefence list con le quali si raggiunge il quorum
  * fallimenti temporanei gestiti mediante hinted handoff: se una put deve scrivere su un nodo temporanemente non disponibile, la richiesta viene reindirizzata ad un altro nodo, il quale è responsabile di rigirarla al nodo originario una volta ristabilità la disponibilità
  * failure detection passiva: ignorati i fallimenti di nodi non coinvolti in richieste dell'utente.

* bassa sicurezza (assume ambiente non ostile in quanto usato internamente)

* data versioning:
  * ad ogni dato è associato un version number
  * versioni concorrenti sono riconciliate richiedendo la risoluzione del conflitto al client

* API CRUD molto semplice:
  * metodi get/put applicabili ad un'unica entità alla volta
  * metodi get/put usati anche per risolvere conflitti (se ci sono versioni in conflitto, la get ritorna una lista di valori con version number)

Un datastore molto simile a Dynamo è *RiakKV*, il quale prevede però anche il supporto per Mesos.

---

## Redis
REmote DIrectory Server (Redis) è un *key-value datastore* in-memory spesso utilizzato per implementare lo *strato di caching*.

Fino al 2015 è stato il più famoso della sua categoria.

Le caratteristiche principali sono:

 * in-memory datastore
 * molte operazioni sono atomiche
 * molto efficiente
 * possibilità di specificare un timeout di validità per le chiavi
 * il valore è (i) una stringa (al più 512MB) o (ii) un contenitore di stringhe (hashmap, list, set, sortedset)
 * la chiave è una stringa ASCII

---

## BigTable
BigTable è un *column-family datastore* sviluppato da Google, disoo disponibile come servizio di Google Cloud Platform e utilizzato in molte applicazioni di Google (e.g. Web indexing, Maps, YouTube).

Le caratteristiche principali sono:

* sistema CP, autonomico, fault-tolerant

* architettura *master-slave*:
  * **Master Server (MS):** unico, gestisce metadati, assegna Tablet ai Tablet Server, gestisce i data schema, load balancing, garbage collection
  * **Tablet Server (TS):** gestisce  tipicamente 1000 Tablet, Read/Write delle proprie Tablet, sharding delle proprie Tablet
  * **Client Library (CL):** interagisce con i Master Server per avere i metadati necessari ad interagire con i Tablet Server, comunica direttamente con Tablet Server per operazioni R/W, esegue caching delle locazioni delle Tablet

* basato su GFS:
  * raw storage su GFS
  * replicazione gestita da GFS

* sharding:
  * sharding ordinato
  * le righe sono organizzate in *Tablet*
  * righe appartenenti ad uno stesso Tablet sono memorizzate insieme
  * ogni Tablet è servita da un solo TS
  * auto-sharding di Tablet troppo grandi
  * ogni Tablet è partizionata in chunk in formato *SSTable*
  * un file SSTable è composto da blocchi di dati da 64KB e un Index per individuare un blocco specifico all'interno del file
  * column-family utilizzate per ottimizzare indexing dei dati

* versioning:
  * ogni cella può avere più versioni di uno stesso valore
  * ad ogni valore è associato un timestamp

* lock disribuito mediante Chubby
  * atomicità operazioni R/W
  * unicità del Master

* I/O atomico su singola riga

* API con operazioni su singolo valore o su range di valori


### Focus: fasi principali
* **Master startup:**
  * il Master acquisisce il MasterLock da Chubby, assicurandosi così di essere l'unico Master attivo
  * il Master registra i server indicati nella Servers Directory di Chubby
  * il Master richiede ad ogni Tablet Server l'elenco delle Table gestite
  * il Master consulta la tabella Metadata per scoprire quali Tablet non sono state ancora assegnate ad un Tablet Server.
* **Tablet Assignment:**
  (i) il Master consulta i Server Lock di Chubby per scoprire quali siano i Tablet Server attivi
  (i) il Master assegna Tablet scoperte al primo Tablet Server disponibile
  (ii) il Master riassegna Tablet servite da Tablet Server non disponibili al primo Tablet Server disponibile
* **Tablet Discovery:** Chubby mantiene un file contenente una Tablet speciale, detta Root Tablet, nella quale sono indicate le locazioni delle Tablet della MetadataTable, cla quale contiene le locazioni di tutte le Tablet.
* **Tablet Serving:** [DA CHIEDERE] le operazioni Write sono registrate in un file su GFS, detto commit log; gli update vengono caricati in memoria all'interno di una struttura detta memtable
* **Tablet Loading:** [DA CHIEDERE]

---

## HBase
Apache HBase è un *column-family datastore* open-source sviluppato come clone di BigTable (stesso data-model, architettura e sharding).
È utilizzato sia per applicazioni batch che per applicazioni real-time.

Le caratteristiche principali sono:

* sistema CP

* architettura *master-slave*:
  * **MasterServer (MS):** gestione mapping region->RegionServer.
  * **RegionServer (RS):** gestiscono la persistenza sul proprio nodo. Possono essere aggiunti/rimossi a runtime per un migliore load-balancing.

* basato su HDFS

* sharding:
  * le righe sono organizzate in *Region* (righe contigue)
  * ogni Region è assegnata ad un RegionServer
  * auto-sharding di Region troppo grandi

* versioning delle celle mediante timestamp associato al valore

* I/O:
  * consistenza forte a livello delle righe, in quanto ogni riga è servita da un unico RegionServer
  * scanning e row-key lookup molto efficienti

* coordinazione mediante Zookeeper

---

## Cassandra
Cassandra è un *column-family datastore* sviluppato da Facebook, noto per (i) alta disponibilità (ii) scalabilità orizzontale (iii) supporto per distribuzione geografica e (iv) bassa latenza.

È stato sviluppato l'intenzione di fondere i punti di forza di Amazon DynamoDB e Google BigTable.

Le caratteristiche principali sono:

* sistema AP
* architettura *masterless* per minimizzare la latenza delle operazioni


* consistenza Read/Write configurabile per ogni query:
  * *ONE*: una sola replica
  * *QUORUM*: la maggioranza delle repliche
  * *ALL*: tutte le repliche
  * *LOCAL_QUORUM*: tutte le repliche dello stesso datacenter

* trade-off tra consistenza e latenza configurabile

* Cassandra Query Language (CQL) come query language SQL-like

---

## MongoDB
MongoDB è un *document datastore* considerato ad oggi un de-facto standard.

Le caratteristiche principali sono:

* i document sono:
  * rappresentati in formato *BSON*, ovvero un'estensione di JSON in formato binario con supporto a più tipi di dato (e.g. timestamp, objectID)
  * identificato da un documentID univoco da utilizzare per fare collegamenti tra document
  * raccolti in collection
* query language semplice e flessibile:
  * filtraggio per selezione document molto semplice
  * dot-notation per indicizzazione di array e esplorazione attributi (e.g, array.2, document.attribute)
  * una query ritorna un cursor per scorrere i document risultanti

---

## Neo4j
Neo4j è un *graph datastore* considerato ad oggi un de-facto standard.

Le caratteristiche principali sono:

* garanzia ACID
* architettura *master-slave*: il master esegue operazioni R/W e gli slave eseguono operazioni Read-Only.
* *multi-level caching* per aumentare il throughput
* *Cypher* come query language SQL-like per operazioni CRUD e *primitive built-in per query sui path* (e.g. shortestPath, allShortestPath)
* nodi e archi taggabili con uno o più *node/edge label* per distinguerne il ruolo nel dominio
