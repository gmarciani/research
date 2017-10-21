# Time-Series Database
I Time-Series Database (TSDB) sono una classe di database per l'*analisi di grandi quantità di serie temporali in modo semplice, efficace e scalabile*.

Le operazioni più frequenti sono: organizzazione, filtraggio, aggregazione e calcolo di statistiche su serie temporali.

Gli esempi applicativi più noti sono *DevOps analytics* e *monitoring IoT*.

Le tecnologie più diffuse sono: *InfluxDB, KairosDB*.

---

## InfluxDB
InfluxDB è un *time-series database* noto per l'alta scalabilità, flessibilità e per la sua appartenenza alla **TICK Stack**, in cui si integra nativamente con *Telegraf* (data ingestion), *Cronograf* (data visualization) e *Kapacitor* (data stream processing).

Le caratteristiche principali sono:

* **schemi flessibili:** non è necessario dichiarare uno schema per i dati.
* **query language SQL-like** per interagire con i dati.
* **data model:** ogni punto della serie temporale è una quadrupla *(timestamp, measure-name, key-value field, key-value metadata)*.
* **downsampling** (e.g. rimozione di dati non necessari) per la conservazione della memoria.
* **REST API** per interagire con il sistema.
