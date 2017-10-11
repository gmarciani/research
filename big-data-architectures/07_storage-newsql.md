# Storage: NewSQL Database
I database NewSQL sono una classe di RDBMS che garantiscono:
* *paradigma ACID* dei database relazionali
* *scalabilità* dei database NoSQL
* *query language SQL*

I database NewSQL più famosi sono: *Google Spanner, VoltDB, Google F1, Clustrix e NuoDB*.

Le architetture NewSQL possono essere:
* **Master/Slave:**, un unico Master riceve le istruzioni I/O e gestisce la replicazione parallela sugli Slave.
* **MultiMaster (anche detto Masterless):**, ogni nodo può ricevere istruzioni I/O e gestisce la mutua replicazione.

---

## Spanner
Spanner è un database NewSQL sviluppato da Google.
È presente nella suite Google Cloud Platform ed è utilizzato internamente da Google per lo storage di Google Ads.

Le caratteristiche principali sono:
* gaanzia ACID: external consistency
* distribuzione geografica su larga scala
* sincronizzazione TrueTime come tecnologia abilitante per external consistency su distribuzione geografica: interval-based global time con accuracy ~1ms
* data model semi-relazionale
* supporto SQL
* versioning dei dati
* I/O:
  * Paxos per eseguire i comandi nello stesso ordine su tutte le repliche
  * transazioni Read/Write con lock
  * transazioni Read-Only distribuite senza lock

---

## VoltDB
VoltDB è un database NewSQL in-memory sviluppato da M. Stonebraker (ACM Turing Award 2015).

La principale motivazione del progetto fu che i tradizionali RDBMS spendono 80% del tempo in paginazione, indexing e gestione della concorrenza e solo il 12% in lavoro specifico.
Questo squilibrio è dovuto alla memorizzazione su file system.

Le caratteristiche principali sono:
* in-memory storage
* garanzia ACID
* alta scalabilità orizzontale
* alta disponibilità
* alta concorrenza
* architettura master-slave: il Master riceve le istruzione e gestisce la replicazione sugli Slave.
* sharding:
  * sharding customizzabile delle tabelle su più nodi
  * replicazione degli shards
  * replicazione selettiva delle tabelle accedute più frequentemente
* transazioni eseguite sequenzialmente da un singolo thread senza locking
* snapshoting continuo o schedulabile
