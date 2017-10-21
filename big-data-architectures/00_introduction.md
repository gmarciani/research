# Introduzione
In questo corso studiamo *principi, patterns, tools e tecnologie* per la progettazione e gestione di sistemi distribuiti per servizi e applicazioni di big data analytics.


## Syllabus
Il programma del corso è il seguente:

* **big data:** definizioni, motivazioni, Modello 7V, Stack Big Data, Processo Big Data, challenges, esempi applicativi.

* **fog computing:** definizioni, motivazioni, OpenFog Consortium, Fog vs Edge Computing, architettura, Modello SCALE.

* **resource management:** definizioni, motivazioni, modello di partizionamento delle risorse (static patitioning, dynamic partitioning), policy di resource management (fair share, max-min fairness, weighted max-min fairness, dominant resource fairness, online dominant resource fairness), Mesos, YARN, Borg, Omega, Kubernetes.

* data storage:
  * distributed file system: GFS, HDFS, Colossus, FDS, Alluxio
  * NoSQL database:
    * key-value: Dynamo, Redis,
    * column-family: BigTable, Cassandra, HBase
    * document: MongoDB
    * graph: Neo4j
  * NewSQL database: Spanner, VoltDB

* **data acquisition:** definizioni, motivazioni, pattern di comunicazione (message queue, publish-subscribe, data transportation), Kafka, Scribe, Sqoop, Flume, Amazon IoT.

* **data processing:**
  * **batch processing:** *DEFINIZIONI ??, MOTIVAZIONI ??, APPLICAZIONE BATCH ??,* Hadoop, Hadoop MapReduce, pattern MapReduce, Pig, Hive, Oozie, Spark.
  * **stream processing:** definizioni, *MOTIVAZIONI ??,* applicazione stream, operatori, modelli di processamento, DSP nel Cloud, Storm, Storn Trident, Heron, Flink, Spark Streaming, Beam.
  * **search database:** definizioni, *MOTIVAZIONI??*, Elasticsearch, Solr.
  * **time-series database:** definizioni, *MOTIVAZIONI ??*, InfluxDB.

È inoltre prevista un'appendice che richiama i fondamenti dei sistemi distribuiti.
