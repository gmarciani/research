# Background

## Modelli di consistenza
* **Eventual:**
* **Serializable:**
* **Atomic:**

## ACID vs BASE
I sistemi di data storage prevedono due modelli di consistenza:

* **ACID:** implementato negli *RDBMS*, altamente consistente, ma non scalabile.
  * **Atomicity:** gli statement di una transazione sono eseguiti tutti o nessuno.
  * **Consistency:** il database è in uno stato consiste prima e dopo una transazione.
  * **Isolation:** una transazione non può vedere risultati parziali di un'altra transazione.
  * **Durability:** le modifiche apportate da una transazione sono resi persistenti prima di essere dichiarate committate.

* **BASE:** implementato nei *Datastore NoSQL*, ideato da *Eric Brewer (autore del teorema CAP)*, altamente scalabile, ma non fortemente consistente.
  * **Basically Available:** il sistema è disponibile, ma può avere sottosistemi temporaneamente non disponibili.
  * **Soft State:** i dati devono essere refreshati
  * **Eventual Consistency:** il sistema converge alla consistenza, ma può avere temporanee inconsistenze.

Il modello ACID è un approccio pessimistico, in quanto orientato alla prevenzione dei conflitti, il che gli impedisce di scalare rizzontalmente.

Il modello BASE è un modello ottimistico, in quanto orientato alla correzione dei conflitti


## Teorema CAP
Il teorema CAP (anche detto Teorema di Brewer) afferma che *è impossibile per un data store distribuito garantire simultaneamente consistenza, disponibilità e tolleranza al partizionamento della rete.*


## Data/Storage Model
Un data model è un insieme di costrutti per la rappresentazione dell'informazione.
Uno storage model è un insieme di modalità con cui il DBMS memorizza e manipola i file sul file system.
Il data model è tipicamente indipendente dallo storage model.


## Consistent Hashing


## Algoritmi di Gossiping


## Algoritmi di quorum


## Chubby
Chubby è un sistema di locking distribuito basato su Paxos e utilizzato in molti prodotti di Google.
