# Questions


## Big Data
* il *modello (3+n)-V* individua le dimensioni con le quali distinguere un dataset tradizionale da un big dataset. Come facciamo a dire che la *visualization* è una di queste dimensioni? Si intende che un big dataset non può essere esplorato se non mediante tecniche di visual analytics?
* un dataset può essere considerato *big dataset* anche se non "eccede" in tutte le dimensioni del modello (3+n)-V?


## Fog Computing
* i termini *Fog Node* e *micro data center* sono sinonimi?
* è corretto affermare che nel *cloud-to-things continuum* i Fog node non devono essere localizzati solo ai bordi della rete, ma pressochè ovunque vi sia domanda computazionale?
* con riferimento alla gerarchia del Fog Computing, quale è la differenza tra lo strato di *operational support* e quello di *business support*?
* con il termine *smart city* si intende l'insieme complessivo di: smart building, smart transportation, smart grid e industry 4.0?
* perchè l'OpenFog Consortium afferma che la *sicurezza* è un vantaggio del Fog Computing? Cosa aggiunge il Fog Computing rispetto al Cloud Computing in termini di sicurezza?
* perchè l'OpenFog Consortium afferma che la *predisposizione all'innovazione* è un vantaggio del Fog Computing? Si intende il fatto che è predisposta ad abilitare nuovi scenari applicativi (e.g. smart city)?


## Resource Management
* in riferimento alle policy di resource management, come affrontare il trade-off tra fairness e overall efficiency?
* i limiti definiti per DRF valgono anche per tutte le altre policy di resource management?
* in riferimento alla fault tolerance in Mesos, se il Master fallisce, chi tiene traccia dei task in esecuzione fino a quel momento in modo da riavviarli una volta rieletto il Master?
* in riferimeno a Borg, cosa si intende per *over-commitment* (slide 72)?
* in riferimento a Borg, con *Alloc* si intende il sottoinsieme di risorse di un nodo assegnabili ad un task, o un insieme di container co-schedulabili (slide 74, slide 84)?
* in riferimento a Kubernetes, i label dei Pod servono solo come descrizione per l'utente, oppure sono a supporto della disciplina di scheduling e allocazione delle risorse?
* in riferimento a Kubernetes, in che senso il Master è un micro-servizio (slide 84)?


## Storage: DFS
* In riferimento a GFS, spiegare operazione Write in figura (slide 19)?
* In riferimento a GFS, la differenza tra write e append è il punto del file in cui viene effettuata la modifica (slide 19)?
* In riferimento a GFS, quale è la differenza fra consistent e defined (slide 21)?
* In riferimento a GFS, cosa comporta la client driven replication praticamente (slide 25)?
* In riferimento a FDS, perché la dimensione fissa dei tract comporta lo stesso throughput per accesso random e sequenziali (slide 27)?
* In riferimento a FDS, quale è la differenza tra location e locators (slid
* In riferimento a FDS, funzionamento della TLT (slide 28)?
* In riferimento ad Alluxio, come funziona precisamente il lineage (slide 30)?
* In riferimento ad Alluxio, si può dire che la sua funzionalità è il caching tra framework e DFS (slide 31)?


## Storage: NoSQL
* in riferimento a Amazon Dynamo, per decentralizzazione P2P si intende l'utilizzo del consistent hashing per lo sharding (slide 32)?
* in riferimento a Amazon Dynamo, la preference list serve per lo Sloppy Quorum (slide 45)?
* in riferimento a Amazon Dynamo, come vengono utilizzati i Merkle Tree per implementare la failure detection (slide 45)?
* in riferimento a datastore column-family, la navigazione dei dati row-oriented è molto inefficiente rispetto a quella column-oriented (slide 46)?
* in riferimento a BigTable, con quale criterio viene assegnata una Tablet ad un Tablet Server (slide 68)?
* in riferimento a BigTable, a cosa serve il Bloom Filter all'interno di un file SSTable (slide 70)?
* in riferimento a BigTable, spiegazione sulla fase di Tablet Serving e Tablet Loading (slide 71-72)?
* in riferimento a Cassandra, per tunable tradeoff tra consistenza e latenza si intende la configurazione del livello di consistenza indicato nelle query (slide 77)?
* in riferimento ai document datastore, perchè non è possibile fare Update senza sostituzione del documento (slide 82)?
* in riferimento ai document datastore, perchè non è conveniente fare query che coinvolgano document con strutture diverse (slide 86)?
* in riferimento a Neo4j, come viene utilizzato il multi-level caching (slide 92)?


## Storage: NewSQL
* come fa VoltDB a garantire transazioni lock-free (slide 12)?


## Data Acquisition
* in riferimento alla API Pub/Sub, il filtro nella subscribe definisce i topic a cui sottoscriversi?
* in riferimento alla API Oub/Sub, perchè la subscribe deve ritornare un subscription handler? Quale è la relazione tra il subscription handler (definito dal sistema) e la callback (definita dal client)?
* possiamo dire che anche la comunicazione Pub/Sub è persistente?
* in riferimento a Kafka, perchè ènecessario partizionare i topic?


## Spark
* possiamo dire che SparkDriver e SparkContext formano insieme il componente Master dell'architettura Spark (slide 18)?
* cosa vuol dire che Spark può essere utilizzato interattivamente mediante la Console di Scala (slide 25)?
* cosa si intende per "lazy" (i.e. materialization on demand) in riferimento alle operazioni di trasformazione (slide 32)?


## Data Stream Processing: Challenges
* come determino la partizione di stato da migrare e la restando parte che fine fa (slide 21)?
* in cosa consiste la active replication, ovvero che differenza c'è tra active replication e replication (slide 26)?


## Data Stream Processing: Frameworks
* in riferimento a Heron, il ruolo del Metrics Manager è il monitoring per lo scheduling semplice o c'è un ciclo MAPE (slide 7)?
* in riferimento a Heron, perchè utilizza Mesos nel setting cluster/testing e Aurora nel setting cluster/production (slide 10)?
* in riferimento a DataFlow, per auto-scaling si intende l'elasticità (slide 30)?
* in riferimento a Kinesis, si può dire che Kinesis è un servizio AWS per realizzare data ingestion in applicazioni DSP (slide 35)?
* in riferimento a Kinesis, Kinesis crea un routing tra istanze EC2 che eseguono operatori DSP (slide 35)?
