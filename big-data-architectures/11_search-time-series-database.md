# Search Database
I Search Database (SDB) sono una classe di database pensata per estrarre caratteristiche complesse dai dati in modo semplice, efficace e scalabile.

## Solr
Apache Solr è un SDB noto per la sua alta scalabilità ed affidabilità.

Utilizzato dalle più famose web application (e.g. LinkedIn, Instagram).

Le caratteristiche principali sono:
* indicizzazione di documenti in molteplici formati (e.g. JSON, CSV, XML, BLOB)
* API REST
* basato su Lucene
* funzionalità di ricerca avanzate: ricerca real-time (real-time indexing), clustering di documenti, ricerce basate su dati geografici.

*Solr Cloud* è la versione distribuita di Solr, che ne permette la scalabilità orizzontale.
Le caratteristiche principali sono:
* sharding degli indici di ricerca
* replicazione degli indici di ricerca
* architettura P2P coordinata da Zookeeper


## ElasticSearch
ElasticSearch è un SDB basato su ricerca full-text, distribuito e altamente scalabile.

Le caratteristiche principali sono:
* schemi flessibili in JSON
* API REST
* basato su Lucene
* sharding degli indici
* replicazione degli indici
* integrazione nativa con Logstash (data ingestion in ElasticSearch) e Kibana (data visualization), formando la cosiddetta *Elastic Stack*.


# Time-Series Database
I Time-Series Database (TSDB) sono una classe di database pensata per analizzare grandi quantità di serie temporali in modo semplice, efficace e scalabile.

Una serie temporale è una sequenza di punti indicizzati dal tempo (istanti temporali o intervalli temporali).

Le operazioni più frequenti sono: organizzazione, filtraggio, aggregazione e calcolo di statistiche su serie temporali.

Gli esempi applicativi più noti sono: analisi metriche DevOps e sensoristica IoT.

Le tecnologie più diffuse sono: *InfuxDB, KairosDB*.


## InfluxDB
InfluxDB è un TSDB.

Le caratteristiche principali sono:
* ogni punto della serie temporale è una tripla (timestamp,key-value field, key-value metadata)
* non è necessario dichiarare uno schema per i dati
* linguaggio SQL-like per interagire con i dati
* REST API per interagire con i dati
* integrazione con Telegraph, Cronograph e Kapacitor, formando la cosiddetta *TICK Stack*.
* conservazione della memoria mediante downsampling
