# Hadoop

Apache Hadoop è un sistema per l'implementazione di applicazioni data-intensive distribuite, scalabilie affidabili.

Fu inizialmente sviluppato da Yahoo! con lo scopo di fornire storage e processing per applicazioni data-intensive.
I componenti core sono:
(i) *HDFS*
(ii) *Hadoop YARN*
(iii) *Hadoop MapReduce*

Hadoop permette di astrarre un cluster complesso costituito da HW commodity e di eseguire su di esso applicazioni data-intensive.


## Ecosistema Hadoop
Hadoop è stato rilasciato dalla Apache Software Foundation nel 2011.
Da allora si sviluppato attorno alla piattaforma un vero e proprio ecosistema di tecnologia per Big Data.
L'ecosistema comprende tecnologie come:
(i) distributed filesystem,
(ii) distributed programming,
(iii) NoSQL datastore,
(iv) NewSQL database,
(v) data ingestion system,
(vi) service programming,
(vii) scheduling,
(viii) machine learning e
(ix) resource management.


## Hadoop MapReduce
MapReduce è un modello computazionale divide-et-impera in cui la computazione è definita come una pipeline distribuita di job, ognuno dei quali è costituito da un *Map Task* (, un eventuale *Combine Task* di aggregazione parziale) ed un *Reduce Task* (ispirato al modello di programmazione Lisp).

I dati di input sono partizionati in *M shard*, dove *M* è il numero di Mapper. L'output di un job è memorizzato nel sottostante DFS: ogni reducer produce una parte di output.

Un *Mapper* è una funzione *map(key1, value1) => list(key2, intermediate_value)* che riceve in input uno shard di entry key-value e produce una lista di entry key-value. Il numero di Mapper deve essere scelto tenendo in considerazione la dimensione dei blocchi HDFS dell'input.

I valori intermedi prodotti dai Mapper sono sottoposti dal *Master Controller* ad una fase di *shuffle grouping* nella quale le entry aventi la stessa chiave sono raggruppati ed inviati ad uno stesso Reducer. Lo spazio delle chiavi intermedie è partizionato tra i Reducer.

Un *Reducer* è una funzione *reduce(key2, list(intermediate_value)) => list(key3, value3)* che riceve in input la lista di valori intermedi per una specifica chiave e produce una lista di entry key-value. Il numero di Reducer è una scelta che deve essere condotta euristicamente.

Tra Mapper e Reducer può essere inserito anche un *Combiner*, il quale esegue una reducing in-memory parziale dei dati nello stesso nodo del Mapper al fine di minimizzare la comunicazione tra Mapper e Reducer. Il framework non fornisce alcuna garanzia sull'esecuzione del Combiner.

Tra Mapper (dopo eventuale Combiner) e Reducer può essere posto un *Partitioner* custom per la partizione delle chiavi sui Reducer. Il fatto che sia customizzabile è utile per implementare politiche di load-balancing e ordinamento.

Hadoop MapReduce è un sistema di data processing che implementa il modello MapReduce.
Il sistema espone una API che rende trasparente il cluster sottostante al programmatore. Il sistema si fa carico di tutto ciò che riguarda (i) parallelizzazione (ii) data distribution (iii) load balancing e (iv) fault tolerance

*Hadoop Streaming API* permette di definire un programma MapReduce usando linguaggi diversi dal Java che leggano lo STDIN e scrivano sullo STDOUT.

Alcuni provider forniscono sistemi preconfigurati con l'installazione dell'ecosistema Hadoop (e.g. Claudera CDH, Hortonworks HDP, MapR, Amazon Elastic MapReduce, Google Cloud Platform).

L'esecuzione di un job MapReduce è guidata da YARN, il quale schedula i task in modo da massimizzare la *data locality*.


### Hadoop Design Patterns
Un design pattern è un template per risolvere una manipolazione di dati che abbia una qualche valenza generale.
L'introduzione si questo concetto si deve a "Design Patterns: elements of reusable object oriented software" della Gang Of Four.
I design pattern sono utilizzati per individuare dei principi di progettazione e per sviluppare software migliore.

I pattern più noti sono:
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
 * Reducer: [fieldKeyToJOIN, ("label"+value)] -> value

* **partitioning:** dividere i record in categorie senza ordinamento sui record.
  * Mapper: funzione identità.
  * Partitioner: associa ad ogni record una partitionKey secondo la disciplina di partizionamento scelta.
  * Reducer: funzione identità.

* **total order sorting:** ordinamento totale dei dati. Ogni Reducer ordina le proprie chiavi, ma non esiste un ordinamento totale su tutti i Reducer. Quindi l'output parziale di ogni Reducer è singolarmente ordinato, ma la loro concatenazione non lo è. È una applicazione MapReduce modellata come due job: fase di analisi e fase di ordinamento.
  * Mapper 1: fa random sampling.
  * Reducer 1: unico, emette un partitionFile
  * Mapper 2:
  * Partitioner 2: partiziona i dati secondo quanto specificato dal PartitionFile
  * Reducer 2: funzione identità.
* **shuffling:** dis-ordinamento del dataset.
  * Mapper: record -> <randomKey, record>
  * Reducer: emette i record ordinati per randomKey


## Pig
Apache Pig è un data processing system di alto livello integrato con lo stack Hadoop che permette di definire applicazioni di data analysis in modo dichiarativo.

Da un punto di vista gerarchico, si colloca nello strato High-Level Interfaces del Big Data Stack.

L'applicazione di data analysis è definita in uno script in *Pig Latin* come una sequenza di trasformazioni.
Lo script viene tradotto dal *Pig Compiler* in un programma MapReduce ottimizzato e direttamente eseguibile dall'Hadoop Job Manager.

Il Pig Latin mette a disposizione tipi built-in (numeri, stringhe, tuple, bag, map) e primitive di storage (LOAD), controllo (FOREACH), filtering (FILTER), aggregation (JOIN, SUM, AVG) e grouping (GROUP BY).

I vantaggi principali sono:
(i) la facilità di definizione dell'applicazione
(ii) l'ottimizzazione dei job MapReduce
(iii) l'estendibilità mediante *User Defined Function (UDF)* scritte in Java, Python o Javascript.

Gli svantaggi principali sono:
(i) lentezza nello sart-up e clean-up dei job MapReduce
(ii) inadeguatezza ad applicazioni *OnLine Analytical Processing (OLAP)*
(ii) difficoltà di debugging


## Hive
Apache Hive è un big data warehouse system integrato con lo stack Hadoop che permette di navigare dati non strutturati memorizzati su HDFS come se fossero strutturati secondo il modello relazionale.

Permette di formulare query mediante linguaggio HiveQL (molto simile al SQL).

Le query sono poi eseguite internamente come job MapReduce.

Il motivo principale per cui è stato sviluppato è la necessità di rendere navigabili i dati provenienti da applicazioni data-intensive come Hadoop MapReduce a color che sono abituato al modello SQL.

Per utilizzare Hive è necessario anzitutto installare un *metastore service*, il quale memorizza i metadati necessari alla navigazione relazionale all'interno di un databse MySQL.


## Ooozie
Apache Oozie è un workflow scheduler integrato con lo stack Hadoop che permette di definire un workflow di job (MapReduce, Pig, Hive,...) in modo dichiarativo.

Un *workflow* è un insieme di azioni organizzate in un *DAG*, ed è definito in modo dichiarativo attraverso uno *script PDL (Process Definition Language)*. Il nodi del DAG possono essere
(i) *Control Node*, responsabili del controllo di flusso (start,end,failure,fork,join,...) o
(ii) *Action Node*, responsabili dell'esecuzione di un task.
Il workflow può essere parametrizzato in funzione di variabili custom.
