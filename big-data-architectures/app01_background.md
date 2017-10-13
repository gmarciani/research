# Appendix A: Background

## ACID vs BASE
I sistemi di data storage prevedono due modelli di consistenza:

* **ACID:** approccio pessimistico, orientato alla prevenzione dei conflitti, implementato negli *RDBMS*, fortemente consistente, ma non scalabile.
  * **Atomicity:** gli statement di una transazione sono eseguiti tutti o nessuno.
  * **Consistency:** il database è in uno stato consistente prima e dopo una transazione.
  * **Isolation:** una transazione non può vedere risultati parziali di un'altra transazione, ovvero è come se la transazioni fossero eseguite sequenzialmente.
  * **Durability:** le modifiche apportate da una transazione sono rese persistenti, anche in presenza di failure.

* **BASE:** approccio ottimistico, orientato alla correzione dei conflitti, implementato nei *Datastore NoSQL*, ideato da *Eric Brewer (autore del teorema CAP)*, altamente scalabile, ma non fortemente consistente.
  * **Basically Available:** il sistema è disponibile, ma può avere sottosistemi temporaneamente non disponibili.
  * **Soft State:** lo stato del sistema ammette un transitorio, ovvero lo stato del sistema può cambiare anche non in presena di transazioni.
  * **Eventual Consistency:** il sistema converge alla consistenza, ma può avere temporanee inconsistenze.


## Data lake
Con data lake si intende una tipologia di storaging in cui i dati sono memorizzati all'interno di un sistema nel loro formato naturale (in forma di BLOB o file), facilitando la collocazione dei dati secondo schemi diversi.


## ETL vs ELT
Il paradigma di analisi dati tradizionale è **Extract-Transform-Load (ETL)**, in cui i dati sono:
* estratti dalle sorgenti e memorizzati temporaneamente in una staging area;
* trasformati nel formato previsto per l'analisi;
* caricati in un data-warehouse.

I Big Data hanno portato all'adozione del nuovo paradigma **Extract-Load-Transform (ELT)**, in cui i dati sono
* estratti dalle sorgenti;
* caricati in un data lake;
* trasformati per l'analisi finale.


## OLTP vs OLAP
Un sistema IT può essere:

* **OnLine Transaction Processing (OLTP):** realizza ETL su datawarehouse, molte transazioni, query poco complesse, massimizzazione del throughput.

* **OnLine Analytics Processing (OLAP):** utilizzato per analizzare i dati memorizzati su datawarehouse, focalizzato sull'analisi dati, minimizzazione della latenza, poche transazioni, query molto complesse.


## Teorema CAP
Il teorema CAP (Consistency, Availability, Partitioning), formulato da Eric Brewer, afferma che *è impossibile per un sistema di data storage distribuito garantire simultaneamente consistenza, disponibilità e tolleranza al partizionamento della rete*. Poichè un sistema distribuito prevede replicazione e sharding dei dati, il designer deve valutare il trade-off tra consistenza e disponibilità. Un sistema distribuito può dunque essere: *CP (Consistency-Partitioning)* o *AP (Availability-Partitioning)*.


## Modelli di consistenza
I modelli di consistenza sono i seguenti, in ordine decrescente di consistenza e crescente di scalabilità:

* **stretta:** ogni processo vede la stessa sequenza di operazioni mediante ordinamento temporale assoluto; ogni transazione è atomica su tutte le repliche; ogni read ritorna il valore scritto piu recentemente.

* **linearizzabile:** ogni processo vede la stessa sequenza di operazioni mediante clock sincronizzato.

* **sequenziale:** ogni processo vede la stessa sequenza di operazioni, eventualmente discorde dalla sequenza realmente avvenuta.

* **causale:** write non concorrenti sono viste da tutti con lo stesso ordinamento, write concorrenti possono essere viste in ordine diverso.

* **finale:** il sistema converge alla consistenza.


## Modelli di comunicazione
Una comunicazione può essere:
* **persistente (transiente):** il middleware memorizza il messaggio sempre (solo se mittente e destinatario sono entrambe in esecuziome), quindi la consegna avviene sempre (soo se sono entrambe in esecuzione).
* **sincrona (asincrona):** invio/ricezione bloccanti (non bloccanti).
* **discreta (streaming):** ogni messaggio inviato contiene l'informaziome per intero (l'informaziome é partizionata in un flusso di tuple).

La semantica di comunicazione può essere:
* **may-be:** non vi è garanzia di consegna del messagio.
* **at-least-once:** il messaggio viene consegnato almeno una volta.
* **at-most-once:** il messaggio viene consegnato al più una volta.
* **exactly-once:** il messaggio viene consegnato esattamente una volta.


## Data/Storage Model
Un data model è un insieme di costrutti per la rappresentazione dell'informazione.
Uno storage model è un insieme di modalità con cui il DBMS memorizza e manipola i file sul file system.
Il data model è tipicamente indipendente dallo storage model.


## Consistent Hashing
Il consistent hashing é un meccanismo di hashing in cui i ridimensiomamento della mappa comporta il remapping di al piú K/N chiavi. Utilizzato per implementare DHT.
Nell hashing standard il ridimensionamento della mappa comporta il remapping di tutte le chiavi.


## Algoritmi di Gossiping
Un protocollo di gossiping é un protocollo di comunicaziome in cui i messaggi sono diffusi nella rete in modo distribuito (come fosse un passaparola).


## Chubby
Chubby è un sistema di locking distribuito basato su Paxos e utilizzato in molti prodotti di Google.


## Chandy-Lamport
L'algoritmo di Chandy-Lamport è un *algoritmo di snapshot distribuito* che permette dunque ad un sistema distribuito di registrate il proprio stato globale. L'algoritmo è basato su un approccio di gossiping, in cui i processi diffondono nel sistema le richieste di snapshot.
