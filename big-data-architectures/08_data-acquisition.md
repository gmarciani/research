# Data Acquisition
La data acquisition è una funzionalità del *layer support/integration* della Big Data Stack.

Lo scopo è acquisire dati da sorgenti distinte al fine di inserirli nel layer di data storage (e.g. all'interno di un DFS per farci Batch Processing) o di immetterli nel layer di data processing (e.g. come data stream per farci DSP).

Questi sistemi vengono usati per:

* **immissione dati** nel sistema.
* **comunicazione asincrona** tra servizi per il *decoupling* e *statelessness* dei componenti.

Questi sistemi si distinguono in base al *pattern della comunicazione*:

* **Message Queue System (MQS):** il producer incoda un messaggio nella message queue di un consumer, il quale viene notificato dalla queue.
Realizza la **comunicazione one-to-one persistente asincrona**.
Le tecnologie più diffuse sono: *RabbitMQ, ZeroMQ, Amazon SQS*.
La API prevede le seguenti chiamate:
  * *put(queue, msg):* inserisce in modo asincrono il messagio nella coda.
  * *get(queue):* estrae in modo sincrono il primo messaggio dalla coda, o cerca un messaggio nella coda mediante pattern-matching.
  * *poll(queue):* estrae in modo asincrono il primo messaggio dalla coda.
  * *notify(queue, func):* installa in modo asincrono una callback da eseguire quando un messaggio è inserito nella coda.

* **Publish-Subscribe System (Pub/Sub):** il producer incoda un messaggio nella message queue relativa al topic del messaggio, il consumer iscritto a quel topic ne richiede i messaggi e si copia il messaggio non ancora letto, il consumer è poi cancellato dalla lista dei subscriber per la ricezione di quel messaggio.
Realizza la **comunicazione one-to-many asincrona**.
Le tecnologie più diffuse sono: *Kafka, Pulsar, Redis*.
La API prevede le seguenti chiamate:
  * *publish(topic, msg):* pubblica un messaggio su uno specifico topic.
  * *subscribe(filter, func, exp) => sub_handler:* installa la sottoscrizione al topic, associando una callback da eseguire quando un nuovo messaggio è pubblicato sul topic; la durata della sottoscrizione è definita da un expiring time; ritorna un handler per ricevere i messaggi del topic.
  * *unsubscribe(sub_handler):* elimina la sottoscrizione al topic.
  * *notify(sub_handler, msg):* eseguita dal sistema Pub/Sub per la consegna di un nuovo messaggio.

* **Data Transportation System (DTS):** trasporto di grandi quantità di dati, da sorgenti eterogenee verso uno o più datastore.
Le tecnologie più diffuse sono: *Scribe, Sqoop*.

* **Data Collection System (DCS):** collezione, aggregazione e trasporto di grandi quantità di dati, da sorgenti eterogenee verso uno o più datastore.
Le tecnologie più diffuse sono: *Flume, Amazon IoT*.

Alcuni framework supportano sia il pattern MQS che Pub/Sub (e.g. RabbitMQ, Kafka).

---

## Kafka
Apache Kafka è un *sistema distribuito di Pub/Sub topic-based*, sviluppato nel 2010 da LinkedIn e noto per la sua alta scalabilità e load balancing.
Oggi è utilizzato da importanti player, come Uber e Netflix.

Le principali caratteristiche sono:

* **architettura master-less:**
  * **Kafka Producer:** produce messaggi.
  * **Kafka Consumer:** consuma messaggi. Un **Consumer Group** è un sottoinsieme di Consumer che condividono uno stesso ID e sono dunque mappati su un unico Consumer logico. Un Consumer può essere eseguito in *modalità Push* (il Broker pusha i nuovi messaggi al Consumer) o *modalità Pull* (Consumer in busy waiting finchè non arriva un messaggio sul topic).
  * **Kafka Cluster:** implementa una collezione di *log append-only time-ordered* (uno per ogni topic) distribuita su un set di server, detti **Kafka Broker**, coordinati tramite *Zookeeper*.
  * **Zookeeper:** coordina Producer, Consumer e Broker (i) mantenendo i metadati (lista dei Broker, lista dei Producer, lista dei Consumer e loro offset), (ii) gestendo la registrazione dei Consumer (iii) garantendo il load balancing degli accessi alle partizioni.

* **sharding:**
  * ogni topic è diviso in **partizioni** (numero di partizioni customizzabile), ovvero una *sequenza numerata, ordinata e immutabile di messaggi*.
  * ogni messaggio è identificato da un **offset**, usato dai Consumer per tenere traccia del punto in cui si è arrivati a leggere.
  * ogni partizione è replicata (grado di replicazione customizzabile).
  * ogni partizione ha un **Broker Leader**, il quale gestisce R/W sulla partizione, e 0 o più **Broker Follower**, che fungono da backup per la partizione.

* **load-balancing:** ogni Broker è leader per alcune partizioni e follower per altre.

* **fault tolerance:** le partizioni sono replicate e i messaggi sono resi disponibili dopo aver raggiunto la consistenza tra leader e follower.

* **comunicazione:** supporta il pattern *MQS* e la *semantica at-least-once*.

* **consistenza:** garantisce *ordinamento totale intra-partizione*, ma non inter-partizione.

* **I/O su page cache:** scrive solo su filesystem page cache, aumentando l'efficienza, ma diminuendo la durabilità.

* API:
  * **Producer API:** permette di pubblicare messaggi su topic.
  * **Consumer API:** permette di gestire iscrizioni ai topic e consumarne i messaggi.
  * **Connector API:** permette di creare Producer e Consumer custom (e.g. data migration tra DB).
  * **Streams API:** permette di definire una pipeline in cui ogni stage è un'applicazione che riceve in input uno stream di dati associato a specifici topic e produce in output uno stream di dati per specifici topic.

* sviluppati client Kafka per molti linguaggi (e.g. Java, Go, Python) e framework (e.g. Flink, Spark, Node.js).
* scritto in Scala

---

## Scribe
Scribe è un *data transportation system* distribuito, usato in Facebook per inviare dati a sistemi batch e real-time.

Le principali caratteristiche sono:

* **alto throughput**.
* **bassa latenza**.
* i dati sono divisi in **category**, ognuna della quali è partizionata in **bucket**.
* i dati sono processati in bucket.
* persistenza su *HDFS*.
* possibilità di fare il *replay dei dati*.

---

## Sqoop
Sqoop è un *data transportation system*, usato per il trasporto di grandi quantità di dati *tra un RDBMS e HDFS, HBase o Hive*.

---

## Flume
Flume è un *data collection system* distribuito per il trasporto di grandi quantità di dati da sorgenti eterogenee verso uno o più datastore.

Le caratteristiche principali sono:

* **architettura componibile:**
  * **Source System:** sistema dal quale si devono estrarre i dati.
  * **Destination System:** sistema nel quale si devno immettere i dati.
  * **Flume Agent:** compinente responsabile del trasporto dei dati da un sistema sorgente ad un sistema destinazione. È costituito dai seguenti componenti:
    * **Source:** legge i dai in formato raw dal sistema sorgente e li immette nel Channel incapsulati in eventi.
    * **Sink:** legge gli eventi dal Channel e li immette nel sistema di destinazione in formato raw.
    * **Channel:** staging area per la gestione del flusso dati da Source a Sink. Vi sono varie tipologie di canale di trasmissione (e.g. in-memory, filesystem, RDBMS, ...).
* fornisce molti *Source e Sink built-in* (e.g. HDFS, Avro).
* permette di definire una **pipeline di trasporto dati**, da un Flume Agent all'altro.

* **alta affidabilità:**
  * *comunicazione transazionale* tra Source e Sink.
  * gli eventi sono rimossi dal Channel solo dopo esser stati memorizzati nella destinazione o in un altro Channel.

* **tuneability:** grado di affidabilità e meccanismi di recovery customizzabili.

* **fault tolerance**

---

## Amazon IoT
Amazon IoT è un *servizio AWS di data collection* pensato per il collezionamento di dati provenienti da *dispositivi IoT* all'interno del Cloud.
