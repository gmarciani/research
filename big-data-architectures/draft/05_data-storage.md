# Data Store

In una applicazione complessa, è encessario utilizzare più di un data store, in base alla funzionalità da implementare.
Questo è uno scenario poliglotta. Con i RDBMS tradizionali si sceglieva un solo DB per tutta la applicazione.


## Key Value
Modelli orientati all'aggregazione dei dati, per organizzare dati con strutture complesse.
Questi omdelli sono guidati dal Domain-Driven Design.

L'aggregato è un BLOB, dunque opaco al DB.

In un data store KV, il valore è un BLOB.
Le query possono fare uso della sola chiave o fare ricerca full-text sul BLOB.
Non tutti supportano ricerca full-text.
La chiave deve essere scelta opportunamente.
Le query sono molto efficienti.
L'operazione di update non permette di intervenire in modo puntuale. Bisogna fare una get, una modifica ed una put.
Tipicamente utilizzato per dati non strutturati.


### DynamoDB


### RIAK KV
Data store key-value ispirato a DynamoDB.
Ne esiste una versione commerciale ed una open-source.
* consistent-hashing con zero-hop (dunque più semplice di Chord).
* i nodi vengono aggiunti/rimossi dal cluster RIAK.
* gossiping per diffondere le modifiche di membership.
* clock vettoriali er risolvere conflitti.
* il conflitto viene risolto dal sistema con last-write-wins; oppure, viene risolto dall'applicazione.
* può essere eseguito su Mesos.


## Column-Oriented
aka *column-family*
è un modello data store fortemente agregate-oriented, ovvero abbiamo capacità più fine di accesso all'aggregato.
Si accede all'aggregato con una chiave, ma l'aggregato è costituito da moltepliciti attributi.
Il modello dei dati è una mappa a due livelli: gli aggregtai sono organizzati in una mappa <chiave,aggregato> e ciascun aggregato è una mappa <column-id, value>.
La struttura dell'aggregato è visibile.
Le colonne possono essere organizzate in *column-families*, che raggruppa le colonne accedute tipicamente insieme.

I dati sono memorizzati per colonne.Quindi il caso d'uso più efficiente è l'accesso per colonne. I valori delle colonne sono memorizzate in settori contigui sul disco, al fine di ridurre I/O.

La differenza sostanziale con i RDBMS è il modo in cui i dati sono acceduti e memorizzati.

Sono adatti a workload di tipo OLAP (Online Analytics Processing) invece di OLTP (OnLine Transaction Processing). In questo tipo di applicazioni sono pochi i campi necessari, ma molti i record da accedere.

Le righe e le colonne sono distribuite su più nodi per aumentare la scalabilità. Utilizzano lo sharding, ovvero partizionano il contenuto su nodi differenti.

Il caso d'uso più efficiente è l'accesso read-intensive e query aggregate.

Ogni riga può avere diverse colonne, la struttura non è statica.

Ciascuna famiglia di colonne definisce un tipo di record.


### Google BigTable
Sviluppato da Google nel 2003, pubblicato nel 2005 come paper.
Utilizza GFS (distributed FS), Chubby (locking basato su Paxos) e SSTable (log-structured storage).
Viene offerto come servizio Cloud (Cloud BigTable).
Usato in tantissime app Google: Web indexing, Map, Earth, Youtube, Gmail, MapReduce.

Il motivo per cui Google ha iniziato a sviluppare questi software, è perchè
* aveva grandi quantità di dati semi.strutturati. Quindi non bastava più usare GFS.
* dati di natura Big Data.

Caratteristiche salienti:
* dati memorizzati come una mappa sparsa multi-livello distribuita.
* fault-tolerant
* scalabile
* autonomico
* soddisfa CP (Consistency e Partition). Può dunque accadere che il sistema sia temporaneamente indisponibile alle scrutture.

Ogni colonna può avere più valori, ognuno dei quali è indeitficato da un timestamp.
Le righe possono essere raggruppate in *tablet*.
Ogni tablet può essere partizionato dal sistema, qualora raggiunga dimensioni eccessive.

Le operazioni di scrittura sono atomiche e possono coinvolgere una sola riga alla votla. Questo è dovuto al fatto che abbiamo scelto consistenza forte.
Per prendre il lock viene usato Chubby.
Le perazioni di lettura sono atomiche e può coninvolgere qualunque entità (riga, cella, colonna,...). Possiamo leggere una sola versione del valore alla volta (es. quella con timestamp più recente.).

Architettura master-slave. Iol master è chiamato *BitgTable Master*. Lo slave è chiamato *BigTable Tablet Server*
Il master è replicato in repliche ombra.
Le Tablet venogno memorizzate nel GFS.
Chubby fa la stessa cosa di Zookeeper per Mesos.
Chubby oltre al locking, gestisce l'elezione del master ombra in caso di fallimento del master.
Le simiglianze con la architetture di GFS  sono dovuta al fatto che è stato sviluppato dallo stesso gruppo di ricerca, più o meno negli stessi anni.
La Client Librayr nn interagisce con il master per I/O, ma interagisce con i Tablet.
Il maste rsi occupa solo della gestione dei metadati.

La tablet viene trovata con una mappa di puntatori a tre livelli.
Il client fa caching della posizione del tablet che sta utilizzando.

*SSTable* è il formato dei dati utilizzato da BigTable.
File ordinato di coppie key-value.

Le operazioni sono memorizzate in un file di log per offrire fault tolerance.
Le tablet non sono replicate su più tablet server, questo per favorire consistenza.
I log permettono di recuperare le tablet in caso di fallimento del tablet server.

Modello di consistenza: consistenza forte.

Il supporto alla replicazione non è nativo in BigTable, ma è implementato da GFS, in quanto ogni blocco viene replicato 3 volte.

Quando unt ablet server fallisce, i dati del tablet non sono disponibile finchè non viene ristabilito il sevrer.


### Apache HBase
Implementazione open-source di Google BigTable.
Non è ottimizzato per mostly-read.
HBase va molto bene in mostly-write.

### Apache Accumulo
Architettura uguale a HBase, ma divers anomenclatura e API.
È meno supportato di HBase, ma ha un migliore servizio di sicurezza.


### Cassandra
Sviluppato inizialmente da Facebook nel 2009.
È un ibrido tra key-value e column-oriented.
Prende alcune idee da
DynamoDB  (architettura P2P, consistent-hashing, gossiping per discovery e error detection) e
da BigTable (usa SSTable, modello dati column-oriented).

Utilizzato da Apple e da Netflix.
Asincrono perchè usa primary-backup.
Alta availability e scalability.
Molto efficienti per scenari write-intensive.

È pensato per distribuzione geografica su larga scala.
Systema AP. Infatti non c'è un singolo master che coordina I/O.
L'utente può fare tuning del livello di consistenza, e si può decidere su ciacuna query.

Scegliendo quorum con W>N/2 +1 si ha consistenza forte evitando dunque conflitti scrittura scrittura.

Consistenza:
* ONE: consistenza finale
* QUORUM: evitiamo o conflitti R/W o W/W
* ALL: consistenza forte
* LOCAL_QUORUM (interessante): poichè distribuzione geografica su larga scala, si fa quorum sul data center locale.

L'utente può anche fare tuning per il tradeoff tra consistenza e latenza.

Il linguaggaio per fare queryè SQL-like.


### Hypertable


### Amazon Redshift

## Document-Based
Documenti indicizzati da chiave. Ogni documento è un dato complesso navigabile.
Tipicamente usati per dati semi-strutturati.
Non sono adatti per operazioni atomiche che riguardano molteplici documenti.
Basse prestazioni quando si fa query su documenti che variano.


### MongoDB
Un documento è un JSON.


### CoachDB


### DocumentDB


### RethinkDB


### RavenDB


## Graph-based
Si perde il concetto di aggregato.
Dati strutturati esplicitamente come un grafo.
Ogni nodo ed ogni relazione ha degli attributi.
Ogni nodo conosce i propri vicini.
Si può impostare un index per il lookup.
Il partizionamento dei dati è difficile -> difficile fare sharding su macchine diverse.
Quindi, rispetto agli altri NoSQL, hanno difficoltà nella scalabilità orizzontale.
TIpicamente utilizzato per applicazioni che devono ricercare e analizzare relazioni fra entità.
Ad esempio: SNA, recommendation e path recognition e path finding.
In un DB SQL avremmo bisogno di nidificare parecchie join per ottenere query su relazioni nativamente supportate da DB  grafo.

### Neo4J
Supporta ACID.
Relazioni unidirezionali.
Architettura a cluster in cui le write vengono fatte su un singolo master, e le letture su più slave.
Il master propaga le repliche sugli slave con replicazione sincrona in mdo da garantire consistenza forte.
Il throughput è aumentato da un caching multilivello.
La funzione Cypher di shortest path utilizza internamente l'algoritmo di Dijkstra.
Possiamo trovare il cammino minimo, o tutti i cammini minimi.


## Benchmark
Non esiste un benchmark ufficiale per la valutazione delle tecnologie NoSQL.
Yahoo Cloud Serving Benchmark (YCSB) è utilizzato come benchmark in letteratura.
Le CPU hanno il benchmark SPEC, le tecnologie NoSQL non ne hanno ancjroa uno equivalente.
Nella conferenza VLDB 2012 si è affrntata la tematica benchmarking.
Un primo scenario è mostly read (95%), mostly writes, only-writes e scan.
Viene valutatio il throughput e la latenza.


## Architetture poliglotte
Tipicamente adottare un unica tecnologia NoSQL ottiene prestazioni basse.
Bisogna fondere più tecnologie per apsetti diversi dell'applicazione.
Anche la sicurezza è un aspetto da considerarsi.


# New SQL
Supportano linguaggio SQL e la replicazione su vasta scala geografica.
I RDBMS tradizionali non scalano orizzontalmente (non supportano scale out su 100-1000 nodi).
L'idea alla base è costruire un servizio DB relazionale che sia però in grado di fare scale-out.
In RDBMS lo scale out è fatto mediante archtetura master-slave con replciazione sincrona.
Le write sono fatte solo sul master.
Essendo replicazione sincrona, le write non scalano oltre una decina di server.

Si adotta dunque una architettura multi-master o master-less, su cui si effettuano le operazioni writes.
Per mantenere consistenza forte, si utilizzano approcci diversi:
Spanner utilizza uno FSM con Paxos (state machine replication)
VoltDB e Clustrix utilizzano session/transaction manager che si occupa di inoltrare le operazioni alle repliche.

### Google Spanner
Primo DB relazionale scalabile su scala globale.
Offerto come servizio cloud.
Google ha sviluppato Spanner perchè approccio key-value non familiare agli sviluppatori.
Inoltre BigTable non va bene per tutte le tipologie di applicazione.

Hnno sviluppato appositamente un nuovo algoritmo di sincronizzazione, chiamato TrueTime.
Approccio transazionale ibrido: Le transazioni in lettura non hanno bisogno di prendere il lock; le transazioni di scrittura hanno bisogno del lock.
Utilizza più versioni dello stesso dato, ad ognuna dei quali è associato un timestamp.


### VoltDB
In-memory DB.
RDBMS spendono 80% del tempo in operazioni di gestione, e solo il 12% in operazioni di read/write.
Questo ha protato allo sviluppo di H-Store.
Iniziato come progetto inter-universitario, H-store
Sviluppato da Michael Stonebraker, ACM Turing Award 2015.
Soluzione commerciale, non offerto open-source.
Con alcuni suoi dottorandi Stonebraker ha fondato la società VoltDB.

VoltDb offre garanzie ACID, alta concorrenza, alta availability, persistenza su disco per fault-tolerance.




### Clustrix


### NuoDB
