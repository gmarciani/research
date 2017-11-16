# Search Database
I Search Database (SDB) sono una classe di database per l'*estrazione di caratteristiche complesse dai dati in modo semplice, efficace e scalabile*.

Le tecnologie più diffuse sono: *Elasticsearch, Solr*.

---

## ElasticSearch
ElasticSearch è un *search database* noto per la sua alta scalabilità e per la sua appartenenza alla **Elastic Stack**, in cui si integra nativamente con *Logstash* (data ingestion) e *Kibana* (data visualization).

Le caratteristiche principali sono:

* **ricerca full-text** basata su *Lucene*.
* **schemi flessibili** in *JSON*.
* **sharding/replicazione degli indici di ricerca** per una maggiore scalabilità e fault-tolerance.
* **API REST** per interagire con il sistema.

---

## Solr
Apache Solr è un *search database* noto per la sua alta scalabilità ed affidabilità.

Utilizzato da grandi player come Apple, LinkedIn e Instagram.

Le caratteristiche principali sono:

* **ricerca full-text** basata su *Lucene*.
* **indicizzazione** di documenti in molteplici formati (e.g. JSON, CSV, XML, BLOB).
* **ricerca avanzata:** ricerca real-time (real-time indexing), clustering di documenti, pagination dei risultati, ricerce basate su dati geografici.
* **API REST** per interagire con il sistema.

**Solr Cloud** è la versione distribuita di Solr, che ne permette la scalabilità orizzontale.

Le caratteristiche principali sono:

* **architettura P2P** coordinata da *Zookeeper*.
* **alta scalabilità e disponibilità:** dovute a:
  * **sharding:** le query sono distribuite su più shards, i risultati parziali sono mergiati;
  * **replicazione:** query concorrenti sono sottomesse a repliche diverse.
