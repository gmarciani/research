# Hadoop
Apache Hadoop è un **sistema per l'implementazione di applicazioni data-intensive distribuite, scalabili, disponibili e affidabili**.

Fu inizialmente sviluppato da Yahoo! con lo scopo di fornire storage e processing per applicazioni data-intensive.

È attualmente utilizzato in production dai maggiori player (e.g. IBM, Facebook, LinkedIn, Twitter).

Hadoop permette di *astrarre un cluster complesso e di eseguire su di esso applicazioni data-intensive*.

Le assunzioni che ne hanno guidato lo sviluppo sono:

* il cluster è composto da *HW commodity* (processori quad-core 2.5 GHz, 24GB RAM, dischi SATA 4TB, Gigabit Ethernet).
* la *larghezza di banda intra-rack è molto maggiore di quella inter-rack*.
* il *fallimento dei nodi* è la norma.


## Ecosistema Hadoop
I componenti principali sono:

* **HDFS** per il data storage.
* **Hadoop YARN** per il resource management.
* **Hadoop MapReduce** per il data processing.

Da quando la Apache Software Foundation lo ha rilasciato nel 2011, vi si è sviluppato attorno un vero e proprio *ecosistema di tecnologie per Big Data*.

L'ecosistema comprende tecnologie come:

* resource management
* distributed filesystem
* NoSQL datastore
* NewSQL database
* data ingestion system
* distributed programming
* scheduling
* machine learning

---

## MapReduce
MapReduce è un **modello computazionale divide-et-impera** ispirato alla programmazione Lisp, in cui la computazione è definita come una pipeline distribuita di job, ognuno dei quali è costituito da un **Map Task** per il partizionamento della computazione, un eventuale **Combine Task** di aggregazione parziale ed un **Reduce Task** per l'aggregazione totale dei risultati parziali.

I dati di input sono partizionati in *M* **Shard**, dove *M* è il numero di Mapper. L'output di un job è memorizzato nel sottostante DFS: ogni reducer produce una parte di output.

Un **Mapper** è una funzione *map(key1, value1) => list(key2, intermediate_value)* che riceve in input uno shard di entry key-value e produce una lista di entry key-value. Il numero di Mapper deve essere scelto tenendo in considerazione la dimensione dei blocchi HDFS dell'input.

I valori intermedi prodotti dai Mapper sono sottoposti dal **Master Controller** ad una fase di **shuffle grouping and sort** nella quale le entry aventi la stessa chiave sono raggruppate ed inviate ordinate ad uno stesso Reducer. Lo spazio delle chiavi intermedie è dunque partizionato tra i Reducer.

Un **Reducer** è una funzione *reduce(key2, list(intermediate_value)) => list(key3, value3)* che riceve in input la lista di valori intermedi per una specifica chiave e produce una lista di entry key-value. Il numero di Reducer è una scelta che deve essere condotta euristicamente.

Tra Mapper e Reducer può essere inserito anche un **Combiner**, il quale esegue uno *step reduce parziale in-memory* dei dati nello stesso nodo del Mapper al fine di minimizzare la comunicazione tra Mapper e Reducer. Il framework non fornisce alcuna garanzia sull'esecuzione del Combiner.

Tra Mapper (dopo eventuale Combiner) e Reducer può essere posto un **Partitioner** per il mapping dello spazio delle chiavi sullo spazio dei Reducer.
Il fatto che sia customizzabile è utile per implementare *politiche di load-balancing e ordinamento*.

---

## Hadoop MapReduce
Hadoop MapReduce è un **sistema di data processing che implementa il modello MapReduce** su cluster di grandi dimensioni (>1000 nodi).
Il sistema espone una API che rende trasparente il cluster sottostante al programmatore.

Il sistema si fa carico di:

* parallelizzazione
* data distribution
* data locality
* load balancing
* fault tolerance

Caratteristiche implementative importanti sono:

* vi è una *implicita operazione group-by e sort* sui dati intermedi prodotti dal Mapper; tale operazione funge da *barrier* tra la fase di Map e la fase di Reduce.
* i risultati intermedi prodotti dal Mapper sono *"spilled" nel disco locale* del nodo che eseguirà il Reducer e non memorizzati sul DFS.
* il numero di Mapper è determinato dal numero di blocchi HDFS in cui è partizionato l'input.
* il numero di Reducer è impostato euristicamente dal programmatore.

**Hadoop Streaming API** permette di definire un programma MapReduce usando linguaggi diversi dal Java che leggano lo STDIN e scrivano sullo STDOUT.
**Elastic MapReduce (EMR)** è un servizio AWS che fornisce un cluster Hadoop preconfigurato, basato su istanze EC2, storage S3 e DyanmoDB.
Un servizio simile è offerto anche da Google Cloud Platform. Alcuni provider forniscono infatti sistemi preconfigurati con l'installazione dell'ecosistema Hadoop (e.g. Claudera CDH, Hortonworks HDP, MapR, Amazon Elastic MapReduce, Google Cloud Platform).

L'esecuzione di un job MapReduce è guidata da *YARN*, il quale schedula i task in modo da massimizzare la *data locality*.

### Limiti
MapReduce ha certamente semplificato il processo di Big Data analysis, ma non è adatto per ogni scenario, in quanto:

* *non tutti gli algoritmi sono facilmente implementabili*.
* *non tutti gli algoritmi sono efficientemente implementabili:* ad esempio, implementare algoritmi con cicli è inefficiente, in quanto ogni iterazione di un ciclo comporta una scrittura/lettura su file.
* necessita la *lettura di tutto l'input*, pertanto non è adatto per applicazioni real-time.
* *modello di programmazione è rigido* se usato per applicazioni multi-stage complesse (e.g. graph analysis e machine learning).
* non sfrutta appieno le potenzialità della memoria.

---

### Hadoop Design Patterns
Un **design pattern** è un template per risolvere una manipolazione di dati che abbia una qualche valenza generale.

L'introduzione si questo concetto si deve a *"Design Patterns: elements of reusable object oriented software" della Gang Of Four*.

I design pattern sono utilizzati per individuare dei principi di progettazione e per sviluppare software migliore.

I **design pattern MapReduce** più noti sono:

* **summarization:** calcolare un valore aggregato.
  * Mapper: record -> [fieldKey, value], dove field è il nome del campo su cui fare aggregazione.
  * Combiner (opzionale): esegue una prima aggregazione
  * Partitioner (opzionale): partizionamento su fieldKey per migliroe load-balancing.
  * Reducer: unico, applica l'aggregazione considerando tutti i valori della chiave fieldKey.

* **filtering:** filtraggio dei dati.
  * Mapper: emette solo i dati che passano il filtro.
  * Reducer: funzione identità.

* **distinct:** esclusione di dati duplicati.
  * Mapper: record -> [record, NULL]
  * Reducer: [record, (NULL)] -> record

* **structure to hierarchical:** aggrega dati strutturati differentemente in una unica struttura più complessa (una sorta di JOIN).
 * Mapper: record -> [fieldKeyToJOIN,"label"+value]
 * Reducer: [fieldKeyToJOIN, ("label"+value)] -> value_complex

* **partitioning:** dividere i record in categorie senza ordinamento sui record.
  * Mapper: funzione identità.
  * Partitioner: associa ad ogni record una partitionKey secondo la disciplina di partizionamento scelta.
  * Reducer: funzione identità.

* **two-stage:** realizzare una computazione complessa mediante una pipeline di job MapReduce.

* **total order sorting:** ordinamento totale dei dati.
Ogni Reducer ordina le proprie chiavi, ma non esiste un ordinamento totale su tutti i Reducer.
Quindi l'output parziale di ogni Reducer è singolarmente ordinato, ma la loro concatenazione non lo è.
È una applicazione MapReduce realizzabile con una pipeline a due stage: fase di analisi e fase di ordinamento.
  * Mapper 1: fa random sampling.
  * Reducer 1: unico, emette un partitionFile
  * Mapper 2:
  * Partitioner 2: partiziona i dati secondo quanto specificato dal PartitionFile (built-in *TotalOrderPartitioner*)
  * Reducer 2: funzione identità.

* **shuffling:** dis-ordinamento del dataset.
  * Mapper: record -> <randomKey, record>
  * Reducer: [randomKey, record]->record

---

## Pig
Apache Pig è un **high-level data processing system** che permette di *definire in modo dichiarativo applicazioni di data analysis da eseguire su cluster Hadoop*.

Da un punto di vista gerarchico, si colloca nello strato *High-Level Interfaces* del Big Data Stack.

L'applicazione di data analysis è definita in uno script in **Pig Latin** come una sequenza di trasformazioni.
Lo script viene tradotto dal **Pig Compiler** in un programma MapReduce ottimizzato e direttamente eseguibile dall'Hadoop Job Manager.

Il Pig Latin fornisce:
* *tipi built-in (numeri, stringhe, tuple, bag, map)*.
* primitive di *storage (LOAD)*.
* primitive di *controllo (FOREACH)*.
* primitive di *filtering (FILTER)*.
* primitive di *aggregation (JOIN, SUM, AVG)*.
* primitive di *grouping (GROUP BY)*.

I vantaggi principali sono:

* *facilità* di definizione dell'applicazione.
* *ottimizzazione* dei job MapReduce.
* *estendibilità* mediante *User Defined Function (UDF)* scritte in Java, Python o Javascript.

Gli svantaggi principali sono:

* *lentezza* nello start-up e clean-up dei job MapReduce.
* inadeguatezza ad applicazioni *OnLine Analytical Processing (OLAP)*.
* *difficoltà di debugging*.

---

## Hive
Apache Hive è un **big data warehouse system** che permette di *navigare dati non strutturati memorizzati su HDFS come se fossero strutturati secondo il modello relazionale*.

Il motivo principale per cui è stato sviluppato è la necessità di rendere navigabili i dati provenienti da applicazioni data-intensive come Hadoop MapReduce a coloro che sono abituati al modello SQL.

Le caratteristiche principali sono:

* **HiveQL** come query language SQL-like.
* query eseguite internamente come job MapReduce.
* metadati per la navigazione relazionale memorizzati su un **metastore service** esterno.

È adatto per eseguire *batch processing su big dataset immutabili*.
Non è adatto per applicazioni OLTP o query real-time.

---

## Ooozie
Apache Oozie è un **workflow scheduler** che permette di *definire in modo dichiarativo un workflow di job (MapReduce, Pig, Hive,...) da eseguire su cluster Hadoop*.

Un *workflow* è un insieme di azioni organizzate in un *DAG*, ed è definito in modo dichiarativo attraverso uno *script PDL (Process Definition Language)* (XML-like).

I nodi del DAG possono essere

* **Control Node**, responsabili del controllo di flusso (start,end,failure,fork,join,...) o
* **Action Node**, responsabili dell'esecuzione di un task.

Il workflow può essere parametrizzato in funzione di variabili custom.
