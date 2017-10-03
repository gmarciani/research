# Spark

MapReduce non è adatto in ogni scenario, in quanto:
* non tutti gli algoritmi sono facilmente implementabili
* non tutti gli algoritmi sono efficientemente implementabili: ad esempio, implementare algoritmi con cicli è inefficiente, in quanto ogni iterazione di un ciclo comporta una scrittura/lettura su file
* non adatto ad applicazioni real-time in quanto necessita la lettura di tutto l'input
* non sfrutta appieno le potenzialità della memoria

Sebbene MapReduce abbia semplificato il processo di Big Data analysis, il suo modello di programmazione risulta rigido per applicazioni multi-stage compelsse (e.g. graph analysis e machine learning). Inoltre è richiesta maggiore efficienza.

Spark è un framework general-purpose di large-scale data processing.
È considerato il successore di Hadoop MapReduce.
Attualmente, è il prodotto di Big Data Analysis più famoso.

Le caratteristiche principali sono:
* in-memory data storage per rendere efficienti le iterazioni (velocità 10x rispetto ad Hadoop MapReduce)
* in-memory data sharing per rendere efficiente interazione tra job paraleli
* scritto in Scala
* API in Scala, Java, Python e R
* può essere usato interattivamente mediante la Console Scala
* scheduling basato su *Mesos*, *YARN* o *Standaline Spark Scheduler* (scheduler interno a Spark)
* Resilient Distributed Dataset (RDD) come astrazione dati. Un RDD è un collezione di dati che possono essere processati in parallelo.
* lo Stack Spark prevede:
  * Spark Core: strato che fornisce funzionalità di base, come scheduling dei task, memory management, fault recovery e interazione con i DFS
  * Spark Tools: collezione di framework sviluppati sopra Spark. I più diffusi sono *Spark SQL* (data warehousing relazionale), *Spark Streaming* (data stream processing), *MLib* (machine learning), *GraphX* (graph analysis).
* architettura Master/Slave
* il programmatore sviluppa la propria applicazione scrivendo un *Driver Program*, nel quale vengono definite lo operazioni da eseguire sul flusso di dati. Il programma interagisce con lo *Spark Context* in modo da rappresentare l'applicazione come task schedulabili, i quali vengono mandati allo Scheduler che ne schedula l'esecuzione all'interno degli Executor eseguiti dai Worker Node. Driver Program e Spark Context realizzano insieme il ruolo di Master.


## RDD
Il Resilient Distributed Dataset (RDD) è la principale astrazione dati di Spark.
È una collezione immutabile e partizionabile di dati processabili in parallelo.
Gli RDD sono partizionati ma non replicati sui nodi del cluster (memorizzati in cache o swappati su disco), e su di essi i worker eseguono il codice.
In caso di fallimento, gli RDD sono ricostruiti con tecnica lineage.
Il numero di partizioni del RDD può essere customizzato.

Un RDD può essere creato:
(i) a partire da collezioni (il livello di partizionamento )
(ii) a partire da file (una partizione per blocco HDFS)
(iii) trasformando un altro RDD (il partizionamento dipende dalla trasformazione)

RDD è adatto per applicazioni di (micro-)batch processing.
RDD non è adatto per applicazioni basate su aggiornamenti asincroni non paralleli (e.g. data storage per web application).

Un programma Spark consiste nella definzione di operazioni su RDD (e.g. map, filter, join, count, average).

Un job Spark è modellata come un DAG in cui
(i) i nodi sono operatori parallelizzabili che eseguono funzioni definite dall'utente.
(ii) gli archi sono il flusso dei dati da un operatore all'altro

Le operazioni che possono essere eseguite su RDD si dividono in due categorie:
* **transformation:** operazioni che trasformano un RDD in un altro RDD (e.g. map, flatMap, filter, reduceByKeyjoin, join, sample).
* **action:** operazioni che computano un valore da un RDD (e.g. count, reduce, take, collect).
* **output:** operazioni di persistenza e visualizzazione (e.g., print, saveAsTextFile).
