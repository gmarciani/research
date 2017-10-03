## Spark

Data processing framework.
MapReduce has several limitations and weaknesses.
* not all programs can be modelled as Map Reduce;
* difficult to structure a program in MR model (e.g. multiple steps for few operations);
* lack of control, structures and data types;
* does not natively provide iteration constructs, so must be piped multiple steps of Map Reduce, with expensive I/O drawbacks;
* not feasible for real-time processing;
* high communication costs;

Top project of Apache.

large scale data batch processing.
It is not a modified version of Hadoop.
At least 10x faster than Hadoop, because in-memory data processing rather than disk.
Compatible with Hadoop storage API, e.g. HDFS and HBase.

architetture master-slave.

Lo SparkContext deve collegarsi con il master per fare scheduling.
Perfettamente integrato con Mesos (stesso gruppo di ricerca).
Interfacciabile con YARN.

Vedere bene RDD ( Resilient Distributed Dataset)

### Bulk Synchronous Parallel (BSP)
developed by L.Valiant in 1980s.


## API
parallelize trasforms an array to a RDD
il numero di partizioni create dal RDD dipende dalle dimensioni del blocco in  HDFS


In python le trasfotmazioni vengono eseguite solo con la chiamata collect().
Questo passaggio è necessario in Python per gestire la rappresentazione dei dati in memoria.
In Scala e Java non è necessario perchè si fa direttamente mentre si dichiara la topologia.

il metodo persist() non implica persistenza su disco, bensì in memoria.
In persist() possiamo specificare il livello di storage.
il metodo cache() è la versione breve di persist()

MEMORY_ONLY: se la memoria finisce, perdiamo parti di RDD
MEMORY_AND_DISK: quando al moemoria finisce, utilizza il disco
MEMORY_ONLY_SER, MEMORY_AND_DISK_SER: memorizza serialiazzando, quindi minimizzando la spazio utilizzato.
Gli RDD sono tolleranti ai guasti
Data locality per assegnare le partizioni ai worker nodes.
