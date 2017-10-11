# Resource Management
Lo *strato di Resource Management* è responsabile della gestione delle risorse di un singolo cluster condiviso da più framework.

Eseguire ogni framework su un cluster dedicato sarebbe infatti costoso e renderebbe difficile la condivisione dei dati.

Un *cluster manager* è un middleware per la condivisione delle risorse di un cluster tra più framework mediante specifiche policy di resource management.
Il middleware rende trasparente il cluster ai framework, astraendolo come un pool di risorse computazionali.
Un *container orchestrator* è un cluster manager per applicazioni multi-container in ambiente cloud.

## Partizionamento delle risorse
Le risorse di un cluster possono essere condivise da framework (eseguiti su VM o container) mediante:
* **static partitioning:** le risorse sono assegnate staticamente ad ogni framework.
* **dynamic partitioning:** le risorse sono assegnate dinamicamente ad ogni framework, proporzionalmente alle necessità di carico.

Le tecnologie di resource management basate su dynamic partitioning realizzano il paradigma **Datacenter as a Computer** teorizzato da D. Patterson, in cui:
* risorse e dati sono condivisi tra più framework per massimizzarne l'utilizzo.
* la complessità del cluster è trasparente alle applicazioni.
* il cluster è accessibile mediante un API unificata.


## Policy di resource management
Una policy di resource management definisce la *disciplina di assegnazione delle risorse condivise ai framework coinvolti*.

Una policy deve soddisfare i seguenti requisiti:
* **share guarantee:** ognuno degli *N* framework deve avere almeno *1/N* della risorsa, ammenochè la sua domanda non sia esplicitamente inferiore.
* **strategy proof:** ai framework non conviene mentire sulla propria domanda.

Le policy più importanti sono:
* **fair sharing:** se una risorsa è condivisa da *N* framework, allora assegna ad ogni framework *1/N* della risorsa.
* **max-min fairness:** se una risorsa è condivisa da *N* framework e *m<N* framework hanno bisogno di al più una frazione di risorsa, allora assegna a questi framework tale frazione ed equipartisce la risorsa restante tra gli altri *N-m* framework.
* **weighted max-min fairness:** se una risorsa è condivisa da *N* framework e ad ognuno di essi è associata una priorità, allora assegna ad ogni framework una frazione di risorsa direttamente proporzionale alla sua priorità.

Queste policy vanno bene se lo spazio delle risorse è unidimensionale.

Se lo spazio delle risorse è multidimensionale, è necessario definire altre policy, come:
* **dominant resource fairness (DRF):** se un vettore di risorse è condiviso da $N$ framework, allora determina per ogni framework la *dominant resource*, ovvero la risorsa con domanda percentuale maggiore (i.e. *dominant share*), e assegna le risorse in modo da uguagliare le dominant share di ogni framework.
* **online DRF:** appena vi sono risorse libere e task da eseguire, presenta offerte di risorse ai framework con la minore dominant share.

Le policy di tipo DRF causano comunque un piccolo sotto-utilizzo delle risorse.

---

## Mesos
Mesos è un cluster manager open source sviluppato dalla Barkeley University.

È divenuto presto top-project della Apache Software Foundation.
Tra gli early adopters conta Twitter e AirBnb ed oggi è utilizzato dalle più importanti applicazioni al mondo.

Le caratteristiche principali sono:

* architettura *master-slave*:
  * **Mesos Master (MM):** eletto da una master pool mediante Zookeeper
  * **Mesos Agent (MA):** eseguito su ogni nodo.
  * **(Framework) Scheduler (FS):** si registra su MM per farsi offrire le risorse.
  * **(Framework) Executor (FE):** lanciato da MA per eseguire uno o più task sul proprio nodo.

* utilizza **Zookeeper** per:
  * sincronizzazione dei componenti
  * elezione del master mediante Paxos
  * condivisione del data tree mediante consistenza primary-backup
  * condivisione dello spazio di naming
  * atomic broadcast

* scheduling:
  * basato su *offerta delle risorse*: gli MA inviano al MM le risorse disponibili; il MM offre risorse agli FS.
  * scheduling *a due livelli*: gli MA inviano al MM le risorse disponibili sul proprio nodo; MM invia ad ogni FS un'offerta di risorse, calcolata secondo la policy di resource allocation; FS seleziona l'offerta di risorse da accettare e i task da eseguire con tali risorse; comunica la propria scelta al MM.
    Scala facilmente, ma è sub-ottimo.
    L'alternativa è lo *scheduling monolitico*, in cui un *global scheduler* ha una visione globale dei task da schedulare, determinando così uno scheduling ottimo. Gli svantaggi sono la complessità dello scheduler, la difficoltà a scalare e la necessità di refactoring quando si aggiunge un nuovo framework.
  * policy di resource allocation **Dominant Resource Fairness (DRF)**.
  * unità di scheduling è il *task*, il quale consiste di uno o più processi in esecuzione sullo stesso nodo. Un framework gestisce ed esegue uno o più *job*, ognuno dei quali è costituito da uno o più task.
  * spazio delle risorse multidimensionale.
  * obiettivi dello scheduling sono: *massimizzazione dell'utilizzo delle risorse, minimizzazione della latenza, massimizzazione della data-locality*.

* fault-tolerance: *task failure, slave failure, host failure, master failure, scheduler failure*.

* agnosticismo ai framework, ma i framework devono essere consapevoli di essere in esecuzione su Mesos.
* supporta i maggiori framework per sistemi distribuiti e scheduling di container.
* supporta i maggiori provider IaaS.
* scalabilità su cluster di 10000 nodi.
* scritto in C++.


### Focus: fault tolerance
Mesos fornisce la tolleranza ai seguenti guasti:

* **task failure:**
  * l'Executor notifica lo Slave;
  * lo Slave notifica il Master;
  * il Master notifica lo Scheduler;
  * lo Scheduler richiede al Master di rischedulare il task;
  * il Master richiede allo Slave di rilanciare il task;
  * l'Executor rilancia il task.

* **Slave failure:**
  * lo Slave si riavvia (essendo un servizio);
  * lo Slave si registra nuovamente sul Master;

* **host failure:**
  * il Master si accorge del fallimento;
  * il Master notifica lo Scheduler del fallimento;
  * lo Scheduler chiede al Master di rilanciare il task;
  * il Master chiede ad un altro Slave di eseguire il task;
  * lo Slave chiede all'Executor di eseguire il task;
  * l'Executor rilancia il task.

* **Master failure:**
  * Zookeeper elegge un nuovo Master dalla Master Pool;
  * Zookeeper notifica gli Slave e gli Scheduler del nuovo Master;
  * gli Slave e gli Scheduler si registrano sul nuovo Master;

* **Scheduler failure:**
  * i relativi task in esecuzione non vengono interrotti;
  * lo Scheduler si riavvia (essendo un servizio);
  * lo Scheduler richiede a Zookeeper l'identità del Master;
  * lo Scheduler si registra sul Master.
  * lo Scheduler si sincronizza con il Master (conosce i propri task in esecuzione).

---

## YARN
YARN (Yet Another Resource Negotiator) è un cluster manager open source nato per lo scheduling di job MapReduce e successivamente reso general-purpose.

Le caratteristiche principali sono:

* architettura *master-slave*:
  * **Resource Manager (RM):** ogni cluster ha un RM (non replicato), il quale è responsabile dell'allocazione delle risorse in risposta alle richieste di job. RM ha una visione globale delle risorse del cluster.
    * **Application Manager:** accetta le *job request* e assegna le risorse secondo quanto indicato dallo Scheduler.
    * **Scheduler:** alloca le risorse per le applicazioni.
  * **Application Master (AM):** ogni applicazione ha un AM, eseguito all'interno di un container, il quale inoltra al RM le richieste di risorse per la relativa applicazione (e.g. numero di container, quantità di risorse per ogni container, preferenze di data locality, ...). Le richieste inoltrate sono *late-binding*, ovvero le risorse allocate non sono vincolate ad una specifica richiesta, ma in generale all'AM (questo perchè la causa della richiesta potrebbe non essere più valida al momento dell'allocazione delle risorse). AM è anche responsabile di monitorare lo stato dei propri container.
  * **Node Manager (NM):** ogni nodo ha un NM. Si registra sul RM, invia il proprio stato al RM, e riceve istruzioni dal RM. Aggiorna RM sulle proprie risorse. Responsabile del ciclo di vita dei container. Configura l'ambiente di esecuzione per i container secondo quanto specificato dai relativi CLC. Responsabile della garbage collection e altri servizi ausiliari

* scheduling:
  * *monolitico*: RM ha una visione globale dello scheduling.
  * basato su *richiesta delle risorse*: gli AM richiedono risorse al RM, in termini di specifiche di container. RM assegna un container, il quale viene inizializzato con il CLC specificato per lanciare il job da AM.
  * discipline di scheduling built-in e custom.
  * spazio delle risorse bidimensionale (CPU, RAM).
  * ottimizzato per job Hadoop.
  * ogni container è descritto da un *Container Launch Context (CLC)* che ne descrive i comandi da eseguire e l'ambiente di esecuzione.

* scritto in Java.

---

## Borg
Borg è un cluster manager sviluppato da Google.

Le caratteristiche principali sono:

* il cluster è partizionato in *celle*, ognuna delle quali raggruppa circa 10K nodi eterogenei.

* architettura *master-slave*:
  * **Borg Master (BM):** ogni cella ha un BM (5 repliche live, ovvero i servizi del BM sono ripartiti sulle repliche). Il BM ha uno Scheduler interno per schedulare i task. Il BM pulla regolarmente le BL per conoscerne lo stato. Il BM è eletto mediante Chubby.
  * **Borglet (BL):** ogni nodo ha un BL, responsabile di gestire e monitorare le risorse del nodo e i task in esecuzione su di esso.


* scheduling:
  * *a due fasi*:
    * **feasibility checking:** viene selezionato un insieme di nodi adatti per il job da schedulare.
    * **scoring:** viene scelto un nodo dal sottoinsieme di quelle selezionati, secondo un mix di preferenze cutom e criteri built-in (e.g. minimizzazione della preemption, massimizzazione data-locality, mixing di task a bassa e alta priorità,...).
  * dichiarativo.
  * la policy di resource allocation fa uso di un *algoritmo euristico di bin-packing* al fine di massimizzare il tasso di utilizzazione delle celle.
  * job preemption.
  * admission control per decidere quali job ammettere per lo scheduling, secondo la priorità del job.
  * monitoring dei task secondo migliaia di metriche di performance.  
  * un *job* è un gruppo di *task*, ognuno dei quali è eseguito all'interno di un *Borg Container*.
  * un *Alloc* è un pool di risorse di un nodo, assegnabile ad un task.

* scalabilità:
  * replicazione del BM.
  * raggruppamento dei task per similarità dei requisiti.
  * caching dello scoring dei nodi.
  * randomizzazione parziale del feasibility checking (inutile calcolare lo score per tutti i nodi).
  * scheduling e BL polling eseguiti su thread separati.  

* prevede sottosistemi utili:
  * **Fauxmaster (FM):** simulatore di scheduling, utilizzato per debugging e valutazione di policy di resource allocation e scheduling.
  * **Borg Name Service (BNS)** come DNS di servizi Borg e dei task.
  * tool di workflow
  * tool di monitoraggio


### Omega
Omega è un'estensione di Borg, in cui lo stato del cluster è memorizzato in uno store centralizzato con transazioni Paxos-based.

---

## Kubernetes
Kubernetes è un container orchestrator open source sviluppato da Google a partire da Omega.

Le caratteristiche principali sono:

* architettura *master-slave*:
  * **Kubernetes Master (KM):** ogni cluster ha un KM.
  * **Kubelet (KL):** ogni nodo ha un KL.
  * **ETCD:** store key-value distribuito e accessibile via REST API, adibito alla memorizzazione e condivisone dello stato del cluster.

* scheduling:
  * ogni task è eseguito in un *Docker Container*.
  * l'unità schedulabile è il *Pod*, il quale raggruppa container co-schedulati sullo stesso nodo.
  * ad ogni Pod sono associati dei *label*, ovvero delle tag key-value che ne forniscono una descrizione per supportare la disciplina di scheduling.
  * le applicazioni sono eseguite su Kubernetes in modo dichiarativo.

* autonomico
* supporto per Cloud publiche, private, ibride e multiple.
* eseguibile sopra Mesos
