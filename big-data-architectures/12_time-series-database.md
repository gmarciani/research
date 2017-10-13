# Time-Series Database
I Time-Series Database (TSDB) sono una classe di database pensata per analizzare grandi quantità di serie temporali in modo semplice, efficace e scalabile.

Una **serie temporale** è una sequenza di punti indicizzati dal tempo (i.e. istanti temporali o intervalli temporali).

Le operazioni più frequenti sono: organizzazione, filtraggio, aggregazione e calcolo di statistiche su serie temporali.

Gli esempi applicativi più noti sono: analytics su metriche DevOps e sensoristica IoT.

Le tecnologie più diffuse sono: *InfluxDB, KairosDB*.

---

## InfluxDB
InfluxDB è un *time-series database* noto per l'alta scalabilità, flessibilità e per la sua appartenenza alla **TICK Stack**, in cui si integra nativamente con *Telegraf* (data ingestion), *Cronograf* (data visualization) e *Kapacitor* (data stream processing).

Le caratteristiche principali sono:

* non è necessario dichiarare uno schema per i dati
* linguaggio SQL-like per interagire con i dati
* ogni punto della serie temporale è una quadrupla *(timestamp, measure-name, key-value field, key-value metadata)*
* conservazione della memoria mediante *downsampling* (e.g. rimozione di dati non necessari)
* REST API
