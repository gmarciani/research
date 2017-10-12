# Data Stream Processing
Il Data Stream Processing (DSP) consiste nel processamento (near)real-time e in-memory di flussi continui di dati ordinati temporalmente (secondo il tempo di arrivo, o secondo timestamp), provenienti da sorgenti distribuite ed eterogenee.

Un'applicazione DSP realizza una **query permanente e reattiva** ai nuovi input, rispettando **vincoli QoS stringenti**.

Un'applicazione DSP è modellata come un *grafo orientato (tipicamente aciclico)*, in cui gli archi sono flussi di dati e i nodi sono operatori potenzialmente paralleli che applicano trasformazioni su di essi.
Nodi particolari sono: *operatori sorgente*, che immettono dati nel sistema, e *operatori sink*, che stabiliscono l'output del processamento.

Un'applicazione DSP può essere implementata attraverso

* un **linguaggio formale** che definisca la composizione degli operatori (e.g. IBM Streams Processing Language).
* la definizione di una **topologia**, ovvero una pipeline espressa come un DAG di operazioni sul flusso di dati.


## Operatori DSP
Un **operatore DSP** è una *unità di processamento auto-contenuta e parallelizzabile* che trasforma uno o più stream di input in uno o più stream di output.

Un operatore DSP può essere:

* **stateless:** non mantiene uno stato, pertanto facilmente parallelizzabile e con restart dopo failure senza procedure di recovery
* **stateful:** mantiene uno stato, pertanto più difficile da parallelizzare e necessitante di procedure di recovery dello stato in caso di failure.

Alcuni framework non permettono di definire internamente lo stato degli operatori, costringendo il programmatore a definirlo utilizzando uno strato di data storage esterno.

Le operazioni può notevoli sono:

* **edge adaptation:** conversione da input a stream e da stream ad output.
* **aggregation:** aggregazione di un sottoinsieme di tuple dello stream.
* **splitting:** partizionamento di uno stream in molteplici stream.
* **merging:** fusione di più stream in un unico stream.
* **logic-math:** trasformazioni logico-matematiche dei cambi delle tuple.
* **sequence-manipulation:** ordinamento delle tuple e modifica dei loro cambi.
* **custom:** trasformazione custom dello stream.

Un tipo particolare di operatore è quello che fa uso del **windowing**, che può essere:

* **count-based:** il buffer è processato ogni *n* tuple.
* **time-based:**  il buffer è processato ogni *x* secondi (reali o simulati).


## Framework DSP
Un sistema DSP è un insieme di nodi computazionali eventualmente eterogenei, ottimizzati per minimizzare l'overhead di comunicazione.

I framework DSP sono progettati per essere eseguiti all'interno di un cluster distribuito localmente.

I framework DSP prevedono due tipologie di processamento:

* **one-at-a-time:** ogni tupla è processata nel momento in cui entra in un operatore. Questa modalità minimizza la latenza.
* **micro-batching:** le tuple vengono raggruppate in un cosidetto *micro-batch* per poi essere processate. Questa modalità massimizza il throughput.

Con il termine **data flow processing framework** si indica una tecnologia finalizzata alla implementazione sia di applicazioni DSP che Batch.


## Challenges
Le sfide più importanti in ambito DSP sono:

* **riduzione della latenza:** il *Fog Computing* permette di avvicinare la computazione alle sorgenti dati, in modo da ridurre la letenza che si osserverebbe in una soluzione Cloud-only.

* **ottimizzazione della topologia:** una applicazione DSP può essere ottimizzata apportando opportune modifiche alla topologia in fase di design o a run-time.
Le ottimizzazioni più rilevanti applicabili agli operatori DSP sono: *riordinamento, separazione, fusione, eliminazione delle ridondanze*.

* **posizionamento degli operatori:** per decidere come distribuire gli operatori DSP sui nodi computazionali è necessario valutare il trade-off tra overhead di comunicazione e risorse computazionali.
Il *DSP Placement Problem* consiste nel determinare il posizionamento ottimo di operatori DSP su un insieme di nodi computazionali.
È un *problema di ottimizzazione NP-Hard* affrontato mediante *programmazione matematica*, *algoritmi euristici* o *algoritmi su grafi*.
L'approccio può essere:
  * **approccio centralizzato:** determina l'ottimo globale, considerando tutta la rete. Non scala.
  * **approccio distribuito:** determina l'ottimo locale considerando le caratteristiche locali della rete. Non garantisce ottimalità globale della soluzione.

* **gestione del workload:** il workload è tipicamente bursty e spiky. I possibili approcci alla gestione delle variazioni del workload sono: *admission control, static reservation (over-provisioning), load shedding (tuple dropping), adaptive rate allocation (backpressure), replacement degli operatori, fissione degli operatori (parallelismo SIMD), rimozione del bottleneck*.

* **elastic stream processing:** scale out/in degli operatori (application layer) e nodi computazionali (infrastructure layer) per rispondere in modo adattativo al workload. È tutt'ora un open issue. Un approccio all'elasticità può utilizzare il ciclo autonomico *Monitor-Analyze.Plan-Execute (MAPE)*. La riconfigurazione del posizionamento degli operatori impatta negativamente le prestazioni dell'applicazione a causa dell'overhead di migrazione degli operatori (specialmente degli operatori stateful).

* **migrazione di operatori stateful:** gli approcci alla migrazione di operatori stateful sono:
  * **pause-and-resume:** arresto operatore su nodo A, salvataggio stato da nodo A, ripristino stato su nodo B, avvio operatore su nodo B. Lo svantaggio di questo approccio è la latenza durante la migrazione.
  * **parallel-track:** operatore su nodo A eseguito parallelamente alla propria replica su nodo B finchè gli stati non sono sincronizzati, arresto operatore su nodo A. Lo svantaggio di questo approccio è la necessità di un meccanismo di sincronizzazione dello stato tra repliche.
Una open issue è l'identificazione della porzione di stato da migrare, la quale può essere (i) determinata dal client mediante API (ii) determinata dal framework supportando **partizionamento dello stato**, in modo da determinare quale porzione dello stato sia necessario migrare.

* **fault-tolerance:** gli approcci di fault-tolerance devono tenere conto del trade-off tra costo di recovery e costo di runtime in assenza di failure.
Gli approcci più diffusi sono: **replicazione**, **check-pointing**, **replay log** o soluzioni ibride.

* **architetture lambda:** sistemi che integrano DSP e batch processing.


## DSP nel Cloud
Le maggiori piattaforme Cloud offrono servizi per implementare applicazioni DSP.

I vantaggi principali sono:

* alta scalabilità
* distribuzione trasparente
* auto-scaling trasparente
* integrazione con altri servizi Cloud

I maggiori servizi Cloud sono:

* **Google DataFlow:** servizio di Google Cloud Platform noto per
  * integrazione nativa con altri servizi Google Cloud Platform.
  * auto-scaling
  * comunicazione exactly-once
  * modello di programmazione uniforme per più pattern (ETL, Batch, DSP) mediante *Beam*

* **Amazon Kinesis Streams:** servizio di AWS noto per
  * integrazione nativa con altri servizi AWS
  * load-balancing tra istanze EC2
  * adaptive sharding
  * fault-tolerance
Mediante *Kinesis Producer Library (KPL)* sorgenti eterogenee possono pushare dati su Kinesis sottoforma di *Kinesis Stream*, ovvero sequenze di *Data Record*, i quali vengono partizionati in *Kinesis Shard* leggibili mediante *Kinesis Client Library (KCL)*.

---

## Storm
Apache Storm è un *DSP framework* open-source.

Inizialmente sviluppato da Twitter.

Le caratteristiche principali sono:

* applicazione definita come un *DAG* in cui i nodi sorgente sono detti *Spout* e tutti gli altri nodi (anche le destinazioni finali) sono detti *Bolt*.
* modello di processamento *one-at-a-time*.
* semantica *at-least-once*.

* architettura *master-slave*:
  * **Nimbus:** nodo master a cui il client sottomette la topologia; responsabile di distribuire e coordinare l'esecuzione della toplogia sui nodi Worker.
  * **WorkerNode:** esegue *WorkerProcess*, ovvero processi Java, ognuno dei quali esegue uno o più *Executor*, all'interno del quale sono eseguiti task co-schedulati.
  Ogni WorkerNode esegue un *Supervisor* che riceve da Nimbus i task da schedulare e notifica periodicamente a Nimbus il proprio stato.
  * **Zookeeper:** mantiene lo stato di esecuzione della topologia.

* data parallelism: uno stream può essere partizionato su più operatori mediante:
  * *shuffle grouping:* randomicamente.
  * *field grouping:* secondo il valore di uno o più attributi della tupla.
  * *all grouping:* lo stream è replicato su tutti gli operatori.
  * *global grouping:* lo stream è inviato interamente ad uno specifico operatore.
  * *direct grouping:* lo stream è inviato interamente ad un operatore esegutio nello stesso Executor.

* applicazione è eseguita sottoponendo la topologia mediante il *TopologySubmitter*, il quale la trasmette a *Nimbus*.
* non supporta operatori stateful.
* due modalità di esecuzione: *local mode* e *cluster mode*.

---

## Storm Trident
Apache Storm Trident è un *DSP framework** sviluppato come estensione di Apache Storm.

Le caratteristiche principali sono:

* modalità *micro-batching per gli spout* -> maggiore throughput

* supporto per *operatori stateful*

* data model *TridentTuple*, ovvero *(inputFields, function, outputFields)*: la tupla di outout contiene sia gli inputField che gli outputField.

* funzioni built-in complesse per aggregazione su partizione di micro-batch:
  * *PartitionAggregator:* sostituzione degli inputField con gli outputField.
  * *CombinerAggregator:* combina i valori di ogni tupla della stessa partizione o esegue una specifica funzione se non sono presenti tuple nella partizione.
  * *ReducerAggregator:* itera su un valore applicandovi una tupla alla volta.
  * *Aggregator:* aggregazione generica.

* semantica *exactly-once* garantita con *Spout (opaque) transactional* e *State transactional*.
  * ad ogni micro-batch è associato un *transactionID (txid)*.
  * classi di spout:
    * *non-transactional:* non garantisce semantica exactly-once.
    * *transactional:* garantisce exactly-once, batch ritrasmessi hanno lo stesso txid, lo stato è aggiornato solo se txid_new > txid.
    * *opaque transactional:* garantisce exactly-once, batch ritrasmessi possono avere anche txid diversi, gli aggiornamenti di stato sono resi idempotenti, in modo da far fronte alle ritrasmissioni.

* stato memorizzabile sia *in-memory* che *in-DB*.

* windowing: *sliding-window* e *tumbling-window*, ma con necessità di bufferizzare la window su storage esterno.


* supporto per operazioni di *JOIN*

---

## Heron
Heron è un *DSP framework* sviluppato da Twitter con l'obiettivo di superare i limiti di performance e affidabilità di Storm.

Le caratteristiche principali sono:

* architettura **master-slave**
  * **Topology Master (TM):** unico, gestisce il ciclo di vita della topologia.
  * **Container (C):** su ogni nodo, comunica con il TM per coordinarsi sul ciclo di vita della topologia.
    * **Stream Manager (SM):** responsabile del routing degli stream, comunica con gli altri SM, responsabile del meccanismo di back-pressure.
    * **Metric Manager (MM):** responsabile del monitoring del nodo e della comunicazione delle statistiche al TM.
* **Storm-compatibility:** la compatibilità con Storm è piena, sia a livello terminologico che a livello di API.
* **isolation:** le topologie sono *process-based* piuttosto che thread-based.
* **resource contraints:** è possibile definire vincoli sull'utilizzo delle risorse, così da renderne sicura l'esecuzione su cluster condiviso.
* **back-pressure:** prevede un meccanismo built-in di back-pressure.
* **tuning latency/throughput:** è possibile fare tuning a grana fine sul trade-off tra latenza e throughput.
* **comunicazione exactly-once/atleast-once:** supporta sia semantica *at-most-once* che *at-least-once*.
* **deployment**: fornisce deployment *standalone/single-node*, *cluster-testing* e *cluster-production*.
* **resource management:** supporta *Mesos* e *Aurora*.

---

## Flink
Apache Flink è un *data flow processing framework* distribuito per lo sviluppo di applicazioni *DSP* e *Batch* da eseguire su cluster di grandi dimensioni (>1000 nodi).

Le caratteristiche principali sono:

* **architettura master-slave:**
  * **JobManager (JM):** unico master, responsabile dello scheduling di task, checkpointing e failure recovery.
  * **TaskManager (TM):** un worker per ogni nodo, responsabile dell'esecuzione dei task e routing degli stream. È composto da (i) una collezione di *Task Slot* per l'esecuzione dei task (uno per ogni task), (ii) un *Memory Manager* per il buffering delle tuple e (iii) un *Network Manager* per la trasmissione degli stream.
* **data flow processing:** è un framework *DSP nativo* che supporta lo sviluppo di applicazioni Batch.
* **Flink Stack:** la software stack prevede:
  * **DataStream API:** sviluppo di applicazioni DSP.
  Su di esso sono stati sviluppati *CEP* (event processing) e *Table* (relational analysis).
  * **DataSet API:** sviluppo di applicazioni Batch.
  Su di esso sono stati sviluppati *FlinkML* (machine learning), *Gelly* (graph analysis) e *Table* (relational analysis).
* **one-at-a-time**: la modalità DSP one-at-a-time permette la minimizzazione della latenza.
* **operatori stateful:** lo stato degli operatori può essere modellato internamente.
* **comunicazione exactly-once**
* **topologie cicliche:** la pipeline può contenere dei feedback.
* **back-pressure:** prevede un meccanismo built-in di back-pressure.
* **fault-tolerance:** la tolleranza ai guasti è garantita da *snapshotting Chandy-Lamport*, *checkpointing barrier* e *watermark*.
* **deployment**: fornisce deployment *local*, *cluster* e *Cloud*.
* **resource management:** supporta *Mesos* e *YARN*.
* **ottimizzazione batch**: fornisce l'ottimizzazione automatica del flusso dati in applicazioni batch, mediante *caching di output intermedi* e *rimozione shuffle&sort inutili*.
* **ordinamento tuple:** non garantisce l'ordinamento delle tuple in stream partizionati; la gestione dell'ordinamento è lasciato all'implementazione dell'operatore.
* **windowing flessibile:** è possibile definire discipline di windowing custom.
* **memory management:** è possibile definire la ripartizione della memoria JVM tra JM e TM; inoltre Flink ottimizza internamente la gestione della memoria JVM.

---

## Spark Streaming
Spark Streaming è un componente della Spark Stack che permette a Spark Core di realizzare applicazioni DSP.

Le principali caratteristiche sono:

* **micro-batching**: un nuovo batch di tuple è generato ogni volta che scade il *batch-interval* definito, tipicamente ogni 500ms.
* **DStream:** i dati fluiscono come una sequenza continua di micro-batch, detta DStream, quindi le operazioni definite sul DStream sono internamente convertite in operazioni sui singoli micro-batch.
* **in-memory:** i risultati parziali in-memory (40x più veloce rispetto a Hadoop MapReduce).
* **data ingestion:** supporta i più famosi framework di data ingestion (e.g., Kafka, Flume) e socket TCP.
* **data extraction:** supporta i più famosi framework di data extraction (e.g., Kafka, Flume, HDFS, Elasticsearch).
* **stateful operators:** supporta operatori stateful.
* **windowing:** supporta trasformazioni di windowing, ma necessità che sia esplicitamente attivato il checkpointing.

---

## Beam
Apache Beam è un *worflow framework* che permette di definire, mediante un modello di programmazione uniforme, pipeline DSP e batch eseguibili dai framework più diffusi (e.g., Flink, Spark, Google DataFlow).
Tipicamente, è impiegato per definire job trivialmente parallelizzabili.
