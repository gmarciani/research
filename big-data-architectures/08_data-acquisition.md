# Data Acquisition

La Data Acquisition si colloca nella Big Data Stack all'interno del layer Support/Integration.
Lo scopo è acquisire dati da sorgenti distinte al fine di inserirli nello storage layer (all'interno di un DFS per farci Batch Processing) o di immetterli nel layer di Data Processing (come data stream per farci Data Stream Processing).

I sistemi di DA vengono usati per immettere i dati nel sistema e per realizzare la comunicazione asincrona tra servizi per il *decoupling* e la *statelessness*.

I sistemi di DA si distinguono in base al *pattern della comunicazione*:

* **Message Queue System (MQS):** Il producer incoda un messaggio nella message queue di un consumer, il quale viene notificato dalla queue. Realizza la *comunicazione one-to-one persistente asincrona*. Esempi notevoli sono: RabbitMQ, ZeroMQ, Amazon SQS.
La API prevede le seguenti chiamate:
  * *put(queue, msg):* inserisce in modo asincrono il messagio nella coda.
  * *get(queue):* estrae in modo sincrono il primo messaggio dalla coda, o cerca un messaggio nella coda mediante pattern-matching.
  * *poll(queue):* estrae in modo asincrono il primo messaggio dalla coda.
  * *notify(queue, func):* installa in modo asincrono una callback da eseguire quando un messaggio è inserito nella coda.

* **Publish-Subscribe System (Pub/Sub):** il producer incoda un messaggio nella message queue relativa al topic del messaggio, il consumer iscritto a quel topic ne richiede i messaggi e si copia il messaggio non ancora letto, il consumer è poi cancellato dalla lista dei subscriber per la ricezione di quel messaggio. Realizza la *comunicazione one-to-many asincrona*.
Esempi notevoli sono: Kafka, Pulsar, Redis.
La API prevede le seguenti chiamate:
  * *publish(topic, msg):* pubblica un messaggio su uno specifico topic.
  * *subscribe(filter, func, exp) => sub_handler:* installa la sottoscrizione al topic, associando una callback da eseguire quando un nuovo messaggio è pubblicato sul topic; la durata della sottoscrizione è definita da un expiring time; ritorna un handler per ricevere i messaggi del topic.
  * *unsubscribe(sub_handler):* elimina la sottoscrizione al topic.
  * *notify(sub_handler, msg):* eseguita dal sistema Pub/Sub per la consegna di un nuovo messaggio.

* **Data Collection System (DCS):** collezione, aggregazione e trasporto di grandi quantità di dati, da sorgenti diverse verso un datastore. Esempi notevoli sono: Flume. Sqoop.

Alcuni framework supportano entrambi i pattern (e.g. RabbitMQ, Kafka).


## Kafka
Apache Kafka è un sistema distribuito di Pub/Sub topic-based, sviluppato nel 2010 da LinkedIn in Scala.

Le principali caratteristiche sono:
* possibilità di implementare MQS
* scalabilità orizzontale
* semantica di comunicazione at-least-once
* fault tolerance: replicazione delle partizioni, messaggi resi disponibili dopo la consistenza tra leader e follower (contro: il messagio potrebbe non essere disponibile immediatamente), i messaggi sono mantenuti per un lasso di tempo configurabile anche dopo essere stati consumati
* esecuzione dei Consumer in modalità *Push* (il Broker pusha i nuovi messaggi al Consumer) o *Pull* (Consumer in busy waiting finchè non arriva un messaggio sul topic)
* garantisce ordinamento totale intra-partizione, ma non inter-partizione.
* scrive solo su filesystem page cache.

Sono stati sviluppati client Kafka per molti linguaggi (e.g. Java, Go, Python) e framework (e.g. Flink, Spark, Node.js).


### Architettura
I componenti principali dell'architettura di Kafka sono:
* **Kafka Producer:**
* **Kafka Consumer:** Un *Consumer Group* è un sottoinsieme di Consumer che cindividono uno stesso ID e sono dunque mappati su un unico Consumer logico.
* **Kafka Cluster:** implementa un log distribuito su un set di server, detti *Kafka Broker*, coordinati tramite *Zookeeper*. Per ogni topic viene mantenuto un *log append-only e time-ordered*. Ogni topic è diviso in un numero predefinito di *partizioni*, ognuna delle quali è replicata secondo un predefinito *replication factor* per garantire la fault-tolerance. Ogni messaggio è identificato da un ID, detto *offset*, usato dai Consumer per tenere traccia del ounto in cui si è arrivati a leggere. Ogni partizione ha un *leader*, il quale gestisce letture/scritture sulla partizione, e 0 o più *follower*, che fungono da backup per la partizione. Ogni broker è leader per alcune partizioni e follower per altre, per garantire load balancing. Zookeeper viene utilizzato per mantenere consistenti leader e broker.
* **Zookeeper:** coordina Producer, Consumer e Broker (i) mantenendo metadati (lista dei Broker, lista dei Producer, lista dei Consumer e loro offset), (ii) gestendo la registrazione dei Consumer (iii) garantendo il load balancing degli accessi alle partizioni.


### API
Kafka dispone di quattro API:

* **Producer API:** permette di pubblicare messaggi su topic.

* **Consumer API:** permette di gestire iscrizioni ai topic e consumarne i messaggi.

* **Connector API:** permette di creare Producer e Consumer custom (e.g. data migration tra DB).

* **Streams API:** permette di definire una pipeline in cui pgni stage è un'applicazione che riceve in input uno stream di dati associato a specifici topic e produce in output uno stream di dati per specifici topic.


## Scribe
Scribe è un sistema distribuito di data transportation, usato in Facebook per inviare dati a sistemi batch e real-time.

Le principali caratteristiche sono:
* data durability con HDFS
* possibilità di fare il replay dei dati
* alto trhoughput
* bassa latenza
* i dati sono processati in bucket: i dati sono divisi in categorie, ognuna della quali è partizionata in bucket.


## Flume
Flume è un data collection system, tipicamente utilizzato per il trasporto di grandi quantità di dati di log.

Le principali caratteristiche sono:
* alta affidabilità: gli eventi sono rimossi dal Channel solo dopo esser stati memorizzati nella destinazione o in un altro Channel, comunicazione transazionale tra Source e Sink.
* alta disponibilità
* tunable reliability
* tunable recovery
* fault tolerance
* permette di definire una pipeline di trasporto dati, da un Flume Agent all'altro.

### Architettura
I principali componenti dell'architettura di Flume sono:

* **Source System:** sistema dal quale si devono estrarre i dati.
* **Destination System:** sistema nel quale si devno immettere i dati.
* **Flume Agent:** macro compinente responsabile del trasporto dei dati dal sistema sorgente al sistema destinazione. È costituito dai seguenti componenti:
  * **Source:** legge i dai in formato raw dal sistema sorgente e li immette nel Channel incapsulati in eventi.
  * **Sink:** legge gli eventi dal Channel e li immette nel sistema di destinazione in formato raw.
  * **Channel:** staging area per la gestione del flusso dati da Source a Sink. Vi sono varie tipologie di canale di trasmissione (e.g. in-memory, filesystem, RDBMS, ...).


## Sqoop
Sqoop è un data collection system, usato per il trasporto di grandi quantità di dati tra un RDBMS e HDFS, HBase o Hive.


## Amazon IoT
Amazon IoT è un servizio AWS di data collection pensato per il collezionamento di dati provenienti da dispositivi IoT all'interno del Cloud.
