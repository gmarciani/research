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

* **Google DataFlow:** servizio di Google Cloud noto per (i) auto-scaling e (ii) integrazione nativa con Beam.
* **Amazon Kinesis Streams:** servizio di AWS noto per (i) load-balancing tra istanze EC2, (ii) adaptive sharding e (iii) fault-tolerance.
Mediante *Kinesis Producer Library (KPL)* sorgenti eterogenee possono pushare dati su Kinesis sottoforma di Kinesis Stream, ovvero sequenze di Data Record, i quali vengono partizionati in Kinesis Shard leggibili mediante *Kinesis Client Library (KCL)*.

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
Apache Storm Trident è un framework DSP sviluppato come estensione di Apache Storm.

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

---

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

---

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

---

## Beam
Apache Beam è un framework che permette di definire, mediante un modello di programmazione uniforme, pipeline DSP e batch eseguibili dai framework più diffusi (e.g., Flink, Spark, Google DataFlow). Tipicamente, è impiegato per definire job trivialmente parallelizzabili.
