# Data Stream Processing
Il Data Stream Processing (DSP) consiste nel processamento (near)real-time e in-memory di flussi continui di dati ordinati temporalmente (secondo il tempo di arrivo, o secondo timestamp), provenienti da sorgenti distribuite ed eterogenee.

Una applicazione DSP deve essere altamente reattiva agli input, rispettando vincoli QoS particolarmente stringenti.

Una applicazione DSP realizza una query permanente reattiva ai nuovi dati immessi nel sistema.

Una applicazione DSP è modellata come un grafo orientato (tipicamente aciclico), in cui gli archi sono flussi di dati e i nodi sono operatori potenzialmente paralleli che applicano trasformazioni su di essi. Nodi particolari sono: operatori sorgente, che immettono dati nel sistema, e operatori sink, che stabiliscono l'output del processamento.

Una applicazione DSP può essere implementata attraverso
(i) un linguaggio formale che definisca la composizione degli operatori (e.g. IBM Streams Processing Language) oppure
(ii) la definizione di una topologia.

Un operatore DSP è una unità di processamento che
(i) trasforma uno o più stream di input in uno o più stream di output
(ii) esegue una funzione definita dall'utente su uno o più stream di input
(iii) può eventualmente essere parallelizzato

Le operazioni può notevoli sono: edge adaptation, aggregation, splitting, merging, operazioni logico-matematiche, ordinamento.
Un tipo particolare di operatore è quello che fa uso del windowing, che può essere count-based (buffer processato ogni n tuple) o time-based (buffer processato ogni x secondi reali/simulati).

Un operatore può essere
(i) *stateless* se non mantiene uno stato, pertanto facilmente parallelizzabile e con restart dopo failure senza procedure di recovery
(ii) *stateful* se mantiene uno stato, pertanto più difficile da parallelizzare e necessitante di procedure di recovery dello stato in caso di failure.
Alcuni framework non permettono di definire internamente lo stato degli operatori, costringendo il programmatore a definirlo utilizzando uno strato di data storage esterno.

Un sistema DSP è un insieme di nodi computazionali eventualmente eterogenei ottimizzati per minimizzare l'overhead di comunicazione. Tale minimizzazione è proprio lo scopo del DSP Placement Problem.

I framework DSP sono progettati per essere eseguiti all'interno di un cluster distribuito localmente.

I framework DSP prevedono due tipologie di processamento:
* *one-at-a-time:* ogni tupla è processata nel momento in cui entra in un operatore. Questa modalità minimizza la latenza.
* *micro-batching:* le tuple vengono raggruppate in un cosidetto microbatch per poi essere processate. Questa modalità massimizza il throughput.


## Challenges
Le sfide più importanti in ambito DSP sono:
* **ottimizzazione della topologia:** una applicazione DSP può essere ottimizzata apportando opportune modifiche alla toplogia in fase di design o a run-time.
Le ottimizzazioni più rilevanti applicabili agli operatori DSP sono: *riordinamento, separazione, fusione, eliminazione delle ridondanze*.
* **posizionamento degli operatori:** per decidere come distribuire gli operatori DSP sui nodi computazionali è necessario valutare il trade-off tra overhead di comunicazione e risorse computazionali. È un problema di ottimizzazione NP-Hard.
* **gestione del workload:** il workload è tipicamente bursty e spiky. I possibili approcci alla gestione delle variazioni del workload sono: *admission control, static reservation (i.e., over-provisioning), load shedding (i.e., tuple dropping), adaptive rate allocation (i.e., backpressure), replacement degli operatori, fissione degli operatori (i.e., parallelismo SIMD), rimozione del bottleneck*.
* **elastic stream processing:** scale out/in degli operatori (application layer) e nodi computazionali (infrastructure layer) per rispondere in modo adattativo al workload. È tutt'ora un open issue. Un approccio all'elasticità può utilizzare il ciclo autonomico *Monitor-Analyze.Plan-Execute (MAPE)*. La riconfigurazione del posizionamento degli operatori impatta negativamente le prestazioni dell'applicazione a causa dell'overhead di migrazione degli operatori (specialmente degli operatori stateful).
* **migrazione di operatori stateful:** gli approcci alla migrazione di operatori stateful sono:
  * *pause-and-resume:* arresto operatore su nodo A, salvataggio stato da nodo A, ripristino stato su nodo B, avvio operatore su nodo B. Lo svantaggio di questo approccio è la latenza durante la migrazione.
  * *parallel-track:* operatore su nodo A eseguito parallelamente alla propria replica su nodo B finchè gli stati non sono sincronizzati, arresto operatore su nodo A. Lo svantaggio di questo approccio è la necessità di un meccanismo di sincronizzazione dello stato tra repliche.
Una open issue è l'identificazione della porzione di stato da migrare, la quale può essere (i) determinata dal client mediante API (ii) determinata dal framework supportando *operatori stateful con stato partizionato*, in modo da determinare quale porzione dello stato sia necessario migrare.
* **load balancing:** come bilanciare il carico su operatori replicati?
* **fault-tolerance:** gli approcci di fault-tolerance devono tenere in conto il trade-off tra costo di recovery e costo di runtime in assenza di failure. Gli approcci più diffusi sono: *replicazione, check-pointing, replay log*.
* **architetture lambda:** sistemi che integrano DSP e batch processing.

---

# DSP Placement Problem
Il DSP Placement Problem consiste nel determinare il posizionamento ottimo di operatori DSP su un insieme di nodi computazionali.
È un problema NP-Hard affrontato mediante (i) programmazione matematica (ii) algoritmi euristici o (iii) algoritmi su grafi.
L'approccio può essere:
* *centralizzato:* determina l'ottimo globale, considerando tutta la rete. Non scala.
* *distribuito:* determina l'ottimo locale considerando le caratteristiche locali della rete. Non garantisce ottimalità globale della soluzione.

---

## Storm
Apache Storm è un framework DSP.

Le caratteristiche principali sono:
* modalità DSP one-at-a-time.
* applicazione è definita come un DAG in cui i nodi sorgente sono detti spout e tutti gli altri nodi (anche le destinazioni finali) sono detti bolt.
* data parallelism: uno stream può essere partizionato su più operatori mediante:
  * *shuffle grouping:* randomicamente
  * *field grouping:* secondo il valore di uno o più attributi della tupla
  * *all grouping:* lo stream è replicato su tutti gli operatori
  * *global grouping:* lo stream è inviato interamente ad uno specifico operatore
  * *direct grouping:* lo stream è inviato interamente ad un operatore esegutio nello stesso Executor
* architettura Master/Slave:
  * *Nimbus:* nodo master a cui il client sottomette la topologia e responsabile di distribuire e coordinare l'esecuzione della toplogia sui nodi Worker.
  * *Zookeeper:* mantiene lo stato di esecuzione della topologia.
  * *Worker Node:* esegue Worker Process, ovvero processi Java, ognuno dei quali esegue uno o più Executor (unità schedulabile), all'interno del quale sono eseguiti task co-schedulati. Ogni Worker Node esegue un *Supervisor* che riceve da Nimbus i task da schedulare e notifica periodicamente a Nimbus il proprio stato.
* due modalità di esecuzione: *local mode* e *cluster mode*.
* applicazione è eseguita sottoponendo la topologia mediante il *TopologySubmitter*, il quale la trasmette a *Nimbus*.
* non supporta operatori stateful.
* semantica at-least-once.


## Storm Trident
Apache Storm Trident è un framework DSP sviluppato come estensione di Apache Storm.
Le caratteristiche principali sono:
* modalità micro-batchhing per gli spout -> maggiore throughput
* windowing: *sliding-window* e *tumbling-window* (i.e., sliding-window dove SlidingInterval=WindowSize), ma con necessità di bufferizzare la window su storage esterno.
* supporto per operatori stateful
* funzioni built-in complesse per aggregazione su partizione di micro-batch:
  * *CombinerAggregator:* combina i valori di ogni tupla della stessa partizione o esegue una specifica funzione se non sono presenti tuple nella partizione.
  * *ReducerAggregator:* itera su un valore applicandovi una tupla alla volta.
  * *Aggregator:* aggregazione generica.
* semantica exactly-once:
  * ogni micro-batch è inviato (eventualemnte reinviato) con lo stesso *transactionID (txid)*.
  * classi di spout:
    * *non-transactional:* non garantisce semantica exactly-once.
    * *transactional:* batch ritrasmessi hanno lo stesso txid, le tuple non sono mai ripetute in batch diversi, le tuple non sono mai omesse.
    * *opache transactional:* batch ritrasmessi possono avere anche txid diversi, le tuple possono essere ritrasmesse in batch diversi.
  * gli aggiornamenti di stato sono resi idempotenti, in modo da far fronte alle ritrasmissioni.
  * supporto per diverse modalità di memorizzazione dello stato: in-memory, in-database.
* supporto per operazioni di JOIN




## Heron
Heron è un framework DSP sviluppato da Twitter come successore di Storm, con l'obiettivo di superarne i limiti di performance e affidabilità.

Le caratteristiche principali sono:
* compatibilità piena con Storm, sia a livello di API che a livello terminologico
* isolation: le topologie sono process-based piuttosto che thread-based.
* possibilità di definire vincoli sull'utilizzo delle risorse, quindi sicuro per esecuzione su cluster condivisi.
* meccanismo built-in di back-pressure
* fine-tuning del trade-off tra latenza e throughput
* supporto per semantica at-most-once e at-least-once
* architettura Master/Slave
  * Topology Master (TM): unico, gestisce tutto il ciclo di vita della topologia
  * Container (C): comunica con il TM per coordinarsi sul ciclo di vita della topologia.
    * Stream Manager (SM): responsabile del routing degli stream, comunica con gli altri SM, responsabile del meccanismo di back-pressure.
    * Metric Manager (MM):
* supporta Mesos
* permette diversi tipi di deployment: standalone/single-node, cluster-testing e cluster-production


## Flink
Apache Flink è un framework di data flow processing distribuiti per lo sviluppo di applicazioni DSP e batch.
Le caratteristiche principali sono:
* framework DSP nativo
* supporto per lo sviluppo di applicazioni batch
* software stack molto ricca:
  * *DataStream API:* sviluppo di applicazioni DSP. Su di esso sono stati sviluppati *CEP* (event processing) e *Table* (relational analysis).
  * *DataSet API:* sviluppo di applicazioni batch. Su di esso sono stati sviluppati *FlinkML* (machine learning), *Gelly* (graph analysis) e *Table* (relational analysis).
* minimizzazione della latenza
* modalità DSP one-at-a-time
* supporto per operatori stateful
* semantica di comunicazione exactly-once
* windowing molto flessibile
* supporto per topologie cicliche
* meccanismo built-in di backpressure
* ottimizzazione automatica del flusso dati in applicazioni batch (e.g., caching di outut intermedi e rimozione di operazioni shuffle&sort inutili)
* fault-tolerance mediante meccanismo Chandy-Lamport mediante checkpointing barrier e watermark
* non garantisce ordinamento di stream partizionati
* architettura Master/Slave
  * JobManager (JM): master, unico, responsabile dello scheduling di task, checkpointing e failure recovery.
  * TaskManager (TM): responsabile per esecuzione dei task (un task per ogni task slot), buffering delle tuple, comunicazione degli stream con altri TM.
* progettato per essere eseguito su custer di grandi dimensioni
* supporto per Mesos e YARN
* modalità di gestione interna della memoria JVM


## Spark Streaming
Spark Streaming è un componente della Spark Stack che permette a Spark Core di processare datastream.
Le principali caratteristiche sono:
* risultati parziali in-memory (40x più veloce rispetto a Hadoop MapReduce).
* supporto per data ingestion dai più famosi framework (e.g., Kafka, Flume) e socket TCP.
* supporto per data extraction verso i più famosi framework (e.g., Kafka, Flume, HDFS, Elasticsearch).
* modello DSP micro-batch (un nuovo batch di tuple è generato ogni volta che scade il batch-interval definito, tipicamente ogni 500ms).
* i dati fluiscono come DStream, ovvero sequenza continua di micro-batch, quindi le operazioni definite sul DStream sono internamente convertite in operazioni sui singoli micro-batch.
* una trasformazione può essere stateless o stateful.
* supporto per trasformazioni di windowing (bisogna specificare windowSize e SlidingInterval).
* l'esecuzione di operazioni di riduzione su windowing, richiede che sia attivato esplicitamente il checkpointing.


## Beam
Apache Beam è un framework che permette di definire, mediante un modello di programmazione uniforme, pipeline DSP e batch eseguibili dai framework più diffusi (e.g., Flink, Spark, Google DataFlow). Tipicamente, è impiegato per definire job trivialmente parallelizzabili.


## DSP nel Cloud
Le maggiori piattaforme Cloud offrono servizi per implementare applicazioni DSP.
I vantaggi principali sono:
* alta scalabilità
* distribuzione trasparente
* auto-scaling trasparente
* integrazione con altri servizi Cloud

I maggiori servizi Cloud sono:
* **Google DataFlow:** servizio di Google Cloud noto per (i) auto-scaling e (ii) integrazione nativa con Beam.
* **Amazon Kinesis Streams:** servizio di AWS noto per (i) load-balancing tra istanze EC2, (ii) adaptive sharding e (iii) fault-tolerance.
Mediante *Kinesis Producer Library (KPL)* sorgenti eterogenee possono pushare dati su Kinesis sottoforma di Kinesis Stream, ovvero sequenze di Data Record, i quali vengono partizionati in Kinesis Shard leggibili mediante *Kinesis Client Library (KCL)*.
