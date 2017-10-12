# Spark
Spark è un *framework general-purpose di large-scale data processing*, considerato il successore di Hadoop MapReduce e attualmente è il prodotto di Big Data Analysis più famoso.

Sviluppato originariamente dalla Barkeley University nel 2009, reso open source nel 2010 e attualmente curato da Databricks.

Le caratteristiche principali sono:

* *in-memory data storage* per rendere efficienti le iterazioni (velocità 10x rispetto ad Hadoop MapReduce)
* *in-memory data sharing* per rendere efficiente l'interazione tra job paralleli
* supporta più tipi di computazione: Batch, DSP, interactive query
* supporto per *HDFS*
* scheduling basato su *Mesos*, *YARN* o *Standalone Spark Scheduler* (scheduler interno a Spark)
* *Resilient Distributed Dataset (RDD)* come astrazione dati. Un RDD è un collezione di dati che possono essere processati in parallelo. Un RDD è partizionato su tutti i nodi.
* architettura *master-slave*
   * il master è realizzato dall'interazione tra *Spark Context* e *Cluster Manager*
   * gli slave sono gli *Spark Executor*: ogni Executor esegue le proprie operazioni sulla propria partizione di RDD.
* il programmatore sviluppa la propria applicazione scrivendo un *Driver Program*, nel quale vengono definite lo operazioni da eseguire sul flusso di dati. Il programma interagisce con lo *Spark Context* in modo da rappresentare l'applicazione come task schedulabili, i quali vengono mandati allo Scheduler che ne schedula l'esecuzione all'interno degli Executor eseguiti dai Worker Node.

* scritto in Scala
* API in Scala, Java, Python e R


## Focus: Spark Stack
Lo *Stack Spark* prevede:

* **Spark Core:** strato che fornisce funzionalità di base, come *task scheduling*, *memory management*, *fault tolerance* e *interazione con DFS*.
* **Spark Tools:** collezione di framework sviluppati sopra Spark.
  * **Spark SQL:**: data warehousing relazionale.
  * **Spark Streaming:** data stream processing.
  * **MLib:** machine learning.
  * **GraphX:** graph analysis.


## Focus: RDD
Il Resilient Distributed Dataset (RDD) è una *collezione immutabile e partizionabile di dati processabili in parallelo* ed è la principale astrazione dati di Spark.

Un RDD è:

* partizionato, con grado di partizionamento customizzabile, sui nodi del cluster (memorizzato in cache o swappato su disco).
* non replicato.
* ricostruito con *tecnica lineage*, in caso di fallimento.
* creato a partire da: collezioni, file, una trasformazione di un altro RDD.
* adatto per applicazioni di (micro-)batch processing.
* non adatto per applicazioni basate su aggiornamenti asincroni non paralleli (e.g. data storage per web application).

Un programma Spark è costituito da una pipeline DAG di operazioni su RDD, in cui:

* i nodi sono operatori parallelizzabili che eseguono funzioni custom su RDD.
* gli archi sono il flusso dei dati da un operatore all'altro.

Le operazioni che possono essere eseguite su RDD si dividono in due categorie:

* **transformation:** operazioni che trasformano un RDD in un altro RDD (e.g. map, flatMap, filter, reduceByKeyjoin, join, sample).
* **action:** operazioni che computano un valore da un RDD (e.g. count, reduce, take, collect).
* **output:** operazioni di persistenza e visualizzazione (e.g., print, saveAsTextFile).
