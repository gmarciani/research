# Storage: NewSQL Database

Gli RDBMS hanno i seguenti vantaggi:
* transazioni ACID
* consistenza forte
* query SQL
* schemi relazionali modificabili senza downtime

Di contro però non sono scalabili orizzontalmente.

I database NewSQL sono una classe di RDBMS che garantiscono:
* *scalabilità* dei database NoSQL
* *paradigma ACID* dei database relationali
* query in *linguaggio SQL*

I database NewSQL più famosi sono: *Google Spanner, Google F1, VoltDB, Clustrix e NuoDB*.

Le architetture NewSQL possono essere:
* *Master/Slave tradizionale*, ovvero un unico Master riceve le istruzioni I/O e gestisce la replicazione parallela sugli Slave
* *MultiMaster (anche detto Masterless)*, nel senso che ogni nodo può ricevere istruzioni I/O e gestisce la mutua replicazione.


## Spanner
Spanner è un database NewSQL sviluppato da Google.

Le caratteristiche principali sono:
* Paxos per eseguire i comandi nello stesso ordine su tutte le repliche
* transazioni ACID
* supporto SQL
* transazioni Read/Write con lock
* transazioni Read-Only distribuite senza lock
* external consistency
* sincronizzazione TrueTime: interval-based global time con accuracy ~1ms
* versionamento dei dati

Spanner è anche reso disponibile come servizio *Spanner Cloud*, nella suite Google Cloud Platform.



## VoltDB
VoltDB è un database NewSQL in-memory.

Le caratteristiche principali sono:
* in-memory
* distribuzione trasparente delle tabelle su più nodi
* replicazione selettiva delle tabelle accedute più frequentemente
* transazioni eseguite sequenzialmente senza lock
* sharding customizzabile
* replicazione degli shards
* snapshot continui o schedulabili

VoltDB garantisce:
* alta scalabilità orizzontalmente
* consistenza: transazioni ACID
* fault-tolerance: relicazione
* alta disponibilità
