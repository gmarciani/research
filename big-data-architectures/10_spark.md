# Spark
Spark è un *framework general-purpose di large-scale data processing*, considerato il successore di Hadoop MapReduce.

Sviluppato originariamente dalla Barkeley University nel 2009, reso open source nel 2010 e attualmente curato da Databricks, oggi è il prodotto di Big Data Analysis più famoso al mondo.

Nel tempo si è sviluppato un set di tecnologie Spark-based, detto **Stack Spark**, composto da:

* **Spark Core:** strato che fornisce funzionalità di base, come *task scheduling*, *memory management*, *fault tolerance* e *interazione con DFS*.
* **Spark Tools:** collezione di framework sviluppati sopra Spark.
  * **Spark SQL:**: data warehousing relazionale.
  * **Spark Streaming:** data stream processing.
  * **MLib:** machine learning.
  * **GraphX:** graph analysis.

Le caratteristiche principali sono:

* **architettura master-slave:**
   * **Spark Context + Cluster Manager (Master):** responsabile del ciclo di vita e deployment dell'applicazione Spark.
   * **Spark Executor (Slave):** su ogni nodo, ognuno dei quali esegue le proprie operazioni sulla propria partizione di RDD.

* **Resilient Distributed Dataset (RDD)** è una *collezione immutabile e partizionabile di dati processabili in parallelo* ed è la principale astrazione dati di Spark. Un RDD è:

  * *partizionato* (grado di partizionamento customizzabile) sui nodi del cluster (memorizzato in cache o swappato su disco);
  * *non replicato*;
  * ricostruito con *tecnica lineage*, in caso di fallimento;
  * creato a partire da: collezioni, file, una trasformazione di un altro RDD;
  * adatto per *applicazioni (micro-)batching*;
  * non adatto per applicazioni basate su aggiornamenti asincroni non paralleli (e.g. data storage per web application).

* **programmazione:** un programma Spark è definito da una **pipeline DAG di operazioni su RDD**. Le operazioni che possono essere eseguite su RDD sono:

  * **transformation:** operazioni che trasformano un RDD in un altro RDD (e.g. *map, flatMap, filter, reduceByKeyjoin, join, sample*).
  * **action:** operazioni che computano un valore da un RDD (e.g. *count, reduce, take, collect*).
  * **output:** operazioni di persistenza e visualizzazione (e.g., *print, saveAsTextFile*).

Il programmatore sviluppa la propria applicazione scrivendo un **Driver Program**, nel quale vengono definite lo operazioni da eseguire sul flusso di dati. Il programma viene sottomesso allo **Spark Context**, il quale lo rappresenta come una collezione di task schedulabili sugli Spark Executor.

* **in-memory data storage/sharing** per rendere efficienti le iterazioni (velocità 10x rispetto ad Hadoop MapReduce) e l'interazione tra job paralleli.

* **computazione:** supporta più tipi di computazione: *Batch, DSP, interactive query*.

* **persistenza:** supporto per *HDFS*.

* **resource management:** scheduling basato su *Mesos*, *YARN* o *Standalone Spark Scheduler* (scheduler interno a Spark).

* API in Scala, Java, Python e R.

* scritto in Scala.
