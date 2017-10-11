# Search Database
I Search Database (SDB) sono una classe di database pensata per estrarre caratteristiche complesse dai dati in modo semplice, efficace e scalabile.
Le tecnologie più diffuse sono: *Elasticsearch, Solr*.

---

## ElasticSearch
ElasticSearch è un SDB distribuito basato su ricerca full-text, noto per la sua alta scalabilità e per la sua appartenenza alla *Elastic Stack*, in cui si integra nativamente con *Logstash* (data ingestion) e *Kibana* (data visualization)

Le caratteristiche principali sono:

* API REST
* ricerca full-text basata su *Lucene*
* schemi flessibili in JSON
* sharding degli indici di ricerca
* replicazione degli indici di ricerca

---

## Solr
Apache Solr è un SDB nasato su ricerca full-text, noto per la sua alta scalabilità ed affidabilità.

Utilizzato da grandi player come Apple, LinkedIn e Instagram.

Le caratteristiche principali sono:

* API REST
* ricerca full-text e indexing basati su *Lucene*
* indicizzazione di documenti in molteplici formati (e.g. JSON, CSV, XML, BLOB)
* funzionalità di ricerca avanzate: ricerca real-time (real-time indexing), clustering di documenti, pagination dei risultati, ricerce basate su dati geografici.

*Solr Cloud* è la versione distribuita di Solr, che ne permette la scalabilità orizzontale.

Le caratteristiche principali sono:

* architettura *P2P* coordinata da *Zookeeper*
* alta scalabilità e disponibilità mediante:
  * *sharding*: le query sono distribuite su più shards, i risultati parziali sono mergiati
  * *replicazione*: query concorrenti sono sottomesse a repliche diverse.