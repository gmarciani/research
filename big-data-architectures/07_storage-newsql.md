# Storage: NewSQL Database
I database NewSQL sono una classe di RDBMS sviluppata con l'obiettivo di unire i vantaggi dei database tradizionali e dei datatsore NoSQL.

Questi database forniscono dunque:

* **garanzia ACID**
* **query language SQL-like**.
* **modello (semi-)relazionale**
* **alta scalabilità**

Le tecnologie più diffuse sono: *Spanner, VoltDB*.

Le architetture NewSQL possono essere:

* **master-slave:** un unico Master riceve le istruzioni I/O e gestisce la replicazione parallela sugli Slave.
* **master-less:** ogni nodo può ricevere istruzioni I/O e gestisce la mutua replicazione.

---

## Spanner
Spanner è un *database NewSQL* sviluppato da Google.

È presente nella suite *Google Cloud Platform* ed è utilizzato internamente da Google per lo storage di *Google Ads*.

Le caratteristiche principali sono:

* **garanzia ACID**

* **distribuzione geografica su larga scala**

* **sincronizzazione TrueTime:** meccanismo di sincronizzazione che realizza la external consistency su distribuzione geografica.

* **I/O:**
  * l'ordinamento delle operazioni è garantito da *Paxos*
  * le transazioni *Read/Write locked* e *Read-Only lock-free*.

* **versioning dei dati**

![Spanner, architettura](img/data-storage-spanner-architecture.png "Spanner, architettura")

---

## VoltDB
VoltDB è un *database NewSQL in-memory* sviluppato da M. Stonebraker (ACM Turing Award 2015).

La principale motivazione del progetto fu che *i tradizionali RDBMS spendono 80% del tempo in paginazione, indexing e gestione della concorrenza e solo il 12% in lavoro specifico*.
Questo squilibrio è dovuto alla memorizzazione su file system.

Le caratteristiche principali sono:

* **garanzia ACID**

* **architettura master-slave**

* **storage in-memory**

* **altissime prestazioni:** alta scalabilità orizzontale e alta disponibilità.

* **sharding:** ogni tabella è partizionata in **shard**, ognuno dei quali è replicato su più nodi, secondo un *grado di replicazione custom per-tabella*.

* **transazioni serializzate:** le transazioni sono eseguite sequenzialmente da un singolo thread senza locking.

* **snapshoting continuo o schedulabile**

![VoltDB, architettura](img/data-storage-voltdb-architecture.png "VoltDB, architettura")
