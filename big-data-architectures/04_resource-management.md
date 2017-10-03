# Resource Management

Lo *strato di Resource Management* è responsabile della gestione delle risorse di un singolo cluster condiviso da più framework.

Eseguire ogni framework su un cluster dedicato sarebbe infatti costoso e renderebbe difficile la condivisione dei dati.

Le risorse di un cluster possono essere condivise da framework eseguiti su VM o container mediante:
* **static partitioning:** le risorse sono assegnate staticamente ad ogni framework.
* **dynamic partitioning:** le risorse sono assegnate dinamicamente ad ogni framework, ovvero proporzionalmente alle necessità di carico.

Le tecnologie di resource management basate su dynamic partitioning realizzano il paradigma **Datacenter as a Computer** teorizzato da D. Patterson, in cui:
* le risorse sono condivise per massimizzarne l'utilizzo
* i dati sono condivise tra più framework
* la complessità del cluster è trasparente alle applicazioni
* il cluster è accessibile mediante un API unificata


La **container orchestration** è l'insieme di operazioni che permettono di definire come selezionare, deployare, monitorare e controllare la configurazione di applicazioni multi-container nel Cloud.
La container orchetsration permette di trasformare un data center da machine-based ad application-based.


## Resource Management Policies
Una policy di resource management definisce la disciplina di assegnazione delle risorse condivise ai framework coinvolti.
Una policy deve soddisfare i seguenti requisiti:
* **share guarantee:** ognuno degli $N$ framework deve avere almeno $\frac{1}{N}$ della risorsa, ammenochè la sua domanda non sia esplicitamente inferiore.

* **strategy proof:** ai framework non conviene mentire sulla propria domanda.

Le policy più importanti sono:

* **fair sharing:** se una risorsa è condivisa da $N$ framework, allora assegna ad ogni framework $\frac{1}{N}$ della risorsa.

* **max-min fairness:** se una risorsa è condivisa da $N$ framework e una parte di essi ha bisogno di al più una frazione $s_{i}$ di risorsa, allora assegna a questi framework tale frazione ed equipartisce la risorsa restante tra gli altri framework.

* **weighted max-min fairness:** se una risorsa è condivisa da $N$ framework e ad ognuno di essi è associata una priorità, allora assegna ad ogni framework una frazione di risorsa direttamente proporzionale alla sua priorità.

Queste policy vanno bene se lo spazio delle risorse è unidimensionale.

Se però lo spazio delle risorse è multidimensionale, è necessario definire altre policy, come:

* **dominant resource fairness (DRF):** se un vettore di risorse è condiviso da $N$ framework, allora determina per ogni framework la *dominant resource*, ovvero la risorsa con domanda percentuale maggiore (i.e. *dominant share*), e assegna le risorse applicando il vincolo di fairness alla dominant resource.

* **online DRF:** presenta offerte di risorsa ai framework con la minore dominant share.

La policy DRF ha comunque i seguenti limiti:
* causa un sotto-utilizzo delle risorse (seppure piccolo)
* causa uno scheduling sub-ottimo dei job, in quanto alloca le risorse secondo i task.


## Apache Mesos
Mesos è un cluster manager che fornisce un middleware per la condivisione delle risorse di un cluster tra più framework mediante dynamic partitioning. Il middleware rende trasparente il cluster ai framework, astraendolo come un pool di risorse computazionali.

È scritto in C++.

È stato sviluppato dalla Barkeley University ed è presto divenuto top-project della Apache Software Foundation.
Tra gli early adopters conta Twitter e AirBnb e ad oggi è utilizzato dalle più importanti applicazioni al mondo.

Da un punto di vista gerarchico si pone tra lo strato IaaS e lo strato PaaS.

I principali obiettivi di Mesos sono:
* massimizzazione dell'utilizzo delle risorse
* agnosticismo ai framework
* scalabilità su cluster di 10000 nodi
* fault-tolerance

Mesos supporta i maggiori framework per sistemi distribuiti e lo scheduling di container (container Docker, Mesos Container o entrambi), riuscendo a scalare fino a 50000 live container.
Mesos può essere deployato sulle maggiori provider IaaS e si sta evolvendo per supportare architettura a micro-servizi.

L'unità computazionale di Mesos è il *task*, il quale consiste di uno o più processi in esecuzione sullo stesso nodo. Un framework gestisce ed esegue uno o più *job*, ognuno dei quali è costituito da uno o più task.

I framework devono essere consapevoli di essere in esecuzione su Mesos.

La condivisione delle risorse è fatta al livello dei task (quindi a grana fine) ed è volta alla massimizzazione dell'utilizzo delle risorse, minimizzazione della latenza e massimizzazione della data locality.

L'architettura è di tipo master-slave.
I componenti dell'architettura sono:
* **Mesos Master:** Il Mesos Master (master) è eletto da una master pool mediante Zookeeper
* **Mesos Agent:** Ogni nodo del cluster esegue un Mesos Agent (slave).
* **(Framework) Scheduler:** si registra al Mesos Master per farsi offrire le risorse.
* **(Framework) Executor:** lanciato dai Mesos Agent per eseguire un task sul proprio nodo.

Mesos utilizza **Zookeeper** per:
* sincronizzazione dei componenti
* elezione del master mediante Paxos
* condivisione del data tree mediante consistenza primary-backup
* condivisione dello spazio di naming
* atomic broadcast

Lo spazio delle risorse è multidimensionale, non solo CPU e RAM.


### Scheduling
Lo scheduling in Mesos è basato su un meccanismo di *offerta delle risorse*.
Gli Agent inviano al Master la quantità di risorse disponibili sul proprio nodo. Il Master le offre ai framework.

Lo scheduler è general purpose.

Lo scheduling segue un'architettura a due livelli (i.e. *two level scheduling*):
* **Mesos-level:** gli Agent inviano al Master le risorse disponibili sul proprio nodo; il Master invia ad ogni framework un'offerta di risorse, calcolata secondo la policy di resource allocation.
* **Framework-level:** lo Scheduler seleziona l'offerta di risorse da accettare e i task da eseguire con tali risorse; comunica la propria scelta al Master.

Lo scheduling a due livelli scala facilmente, è agnostico ai framework, ma può determinare uno scheduling sub-ottimo.

In generale, l'alternativa allo scheduling allo scheduling a due livelli è lo scheduling monolitico. In quest'ultima soluzione vi è un *global scheduler* che ha una visione globale dei task da schedulare. Il vantaggio è la possibilita di determinare uno scheduling ottimo. Gli svantaggi sono la complessità dello scheduler, la difficoltà a scalare e la necessità di refactoring quando si aggiunge un nuovo framework.

I framework e i Mesos Agent registrano la propria presenza sul Mesos Master.

Il Mesos Master invia le resource offer agli Scheduler dei framework.


L'allocazione delle risorse è basata su **Dominant Resource Fairness (DRF)**.


### Fault Tolerance
Mesos fornisce la tolleranza ai seguenti guasti:

* **task failure:** se un task fallisce:
  * l'Executor notifica lo Slave;
  * lo Slave notifica il Master;
  * il Master notifica lo Scheduler;
  * lo Scheduler richiede al Master di rischedulare il task;
  * il Master richiede allo Slave di rilanciare il task;
  * l'Executor rilancia il task.

* **Slave failure:** se uno Slave fallisce:
  * lo Slave si riavvia (essendo un servizio);
  * lo Slave si registra nuovamente sul Master;

* **host failure:** se un host fallisce:
  * il Master si accorge del fallimento;
  * il Master notifica lo Scheduler del fallimento;
  * lo Scheduler chiede al Master di rilanciare il task;
  * il Master chiede ad un altro Slave di eseguire il task;
  * lo Slave chiede all'Executor di eseguire il task;
  * l'Executor rilancia il task.

* **Master failure:** se il Master fallisce:
  * Zookeeper elegge un nuovo Master dalla Master Pool;
  * Zookeeper notifica gli Slave e gli Scheduler del nuovo Master;
  * gli Slave e gli Scheduler si registrano sul nuovo Master;

* **Scheduler failure:** se uno Scheduler fallisce, i relativi task in esecuzione non vengono interrotti e:
  * lo Scheduler si riavvia (essendo un servizio);
  * lo Scheduler richiede a Zookeeper l'identità del Master;
  * lo Scheduler si registra sul Master.
  * lo Scheduler si sincronizza con il Master (conosce i propri task in esecuzione).


## Apache Hadoop YARN
YARN (Yet Another Resource Negotiator) è un cluster manager nato per lo scheduling di job MapReduce.
È scritto in Java.
Ad oggi supporta molteplici framework e non è limitato al modello computazionale MapReduce.

Ogni container è descritto da un *Container Launch Context (CLC)* che ne descrive i comandi da eseguire e l'ambiente di esecuzione.

I componenti dell'architettura YARN sono:
* **Resource Manager (RM):** ogni cluster ha un RM (non replicato), il quale è responsabile dell'allocazione delle risorse in risposta alle richieste di job. RM ha una visione globale delle risorse del cluster
  * **Application Manager:** accetta le *job request* e assegna le risorse secondo quanto indicato dallo Scheduler.
  * **Scheduler:** alloca le risorse per le applicazioni, secondo policy di resource allocation e algoritmi di scheduling (predefiniti o custom pluggable).
* **Application Master (AM):** ogni applicazione ha un AM, eseguito all'interno di un container, il quale inoltra al RM le richieste di risorse per la relativa applicazione (e.g. numero di container, quantità di risorse per ogni container, preferenze di data locality, ...). Le richieste inoltrate sono *late-binding*, ovvero le risorse allocate non sono vincolate ad una specifica richiesta, ma in generale all'AM (questo perchè la causa della richiesta potrebbe non essere più valida al momento dell'allocazione delle risorse). AM è anche responsabile di monitorare lo stato dei propri container.
* **Node Manager (NM):** ogni nodo ha un NM, eseguito come un servizio daemon. Si registra sul RM, invia il proprio stato al RM, e riceve istruzioni dal RM. Aggiorna RM sulle proprie risorse. Responsabile del ciclo di vita dei container. Configura lambiente di esecuzione per i container secondo quanto specificato dai relativi CLC. Responsabile della garbage collection. Espone ulteriori servizi ausiliari, come output intermedi prodotti da container diversi.


### Scheduling
Lo scheduling di YARN è basato su un meccanismo di *richiesta delle risorse*.

I framework richiedono risorse al Resource Manager, in termini di specifiche di container.
RM assegna un container, il quale viene inizializzato con il CLC specificato per lanciare il job dall'Application Master.

Lo scheduler è stato reso general-purpose, ma è stato progettato ed ottimizzato per i job Hadoop.

Lo spazio delle risorse è bidimensionale: CPU e RAM.


## Google Borg
Borg è un cluster manager sviluppato da Google.

Un cluster è partizionato in *celle*, ognuna delle quali raggruppa circa 10K nodi eterogenei.

Le applicazioni sono eseguite su Kubernetes in modo dichiarativo.

Un *job* è un gruppo di *task*, ognuno dei quali è eseguito all'interno di un container dedicato.

Ogni task è eseguito in un *Borg Container*. Ogni container risponde su una porta univoca all'IP del nodo in cui è eseguito.

Con *Alloc* si intende un pool di risorse di un nodo, assegnabile ad un task.

Le caratteristiche principali sono:
* scheduling dichiarativo
* job preemption
* admission control per decidere quali job ammettere per lo scheduling, secondo la priorità del job
* monitoring dei task secondo migliaia di metriche di performance
* Borg Name Service (BNS) come DNS di servizi Borg e dei task
* elezione del master mediante Chubby
* autoscaling orizzontale e verticale
* tool di workflow
* tool di monitoraggio


### Architettura
Borg ha un'architettura *master-slave*.
I componenti dell'architettura di Borg sono:
* **Borg Master (BM):** ogni cella ha un BM (5 repliche live, ovvero i servizi del BM sono ripartiti sulle repliche). Il BM ha uno Scheduler interno per schedulare i task. Il BM pulla regolarmente le BL per conoscerne lo stato.
* **Borglet (BL):** ogni nodo ha un BL, responsabile di gestire e monitorare le risorse del nodo e i task in esecuzione su di esso.
* **Fauxmaster (FM):** simulatore di scheduling, utilizzato per debugging e valutazione di policy di resource allocation e scheduling.


### Scheduling
Lo scheduling in Borg è a due fasi:
* **feasibility checking:** viene selezionato un insieme di nodi adatti per il job da schedulare.
* **scoring:** viene scelto un nodo dal sottoinsieme di quelle selezionati, secondo un mix di preferenze cutom e criteri built-in (e.g. minimizzazione della preemption, massimizzazione data-locality, mixing di task a bassa e alta priorità,...).

La policy di resource allocation fa uso di un algoritmo euristico di bin-packing al fine di massimizzare il tasso di utilizzazione delle celle.

La scalabilità è garantita da:
* scheduling e BL polling eseguiti su thread separati
* replicazione del BM
* raggruppamento dei task per similarità dei requisiti
* caching dello scoring dei nodi
* randomizzazione parziale del feasibility checking (i nutile calcolare lo score per tutti i nodi)


### Google Omega
Omega è un'estensione di Borg, in cui lo stato del cluster è memorizzato in uno store centralizzato con transazioni Paxos-based.


## Google Kubernetes
Kubernetes è un cluster manager open source, sviluppato da Google a partire da Omega.

Le caratteristiche principali sono:
* pensato nativamente per fornire container orchestration.
* portabile su Cloud publiche, private, ibride e multiple.
* estendibile
* autonomico
* eseguibile sopra Mesos

Le applicazioni sono eseguite su Kubernetes in modo dichiarativo.

Ogni task è eseguito in un *Docker Container*. Ogni container risponde ad un priorio IP.


### Architettura
Kubernetes ha un'architettura *master-slave*.
I componenti dell'architettura di Kubernetes sono:
* **Kubernetes Master (KM):** ogni cluster ha un KM.
* **Kubelet (KL):** ogni nodo ha un KL.
* **ETCD:** store key-value distribuito e accessibile via REST API, adibito alla memorizzazione e condivisone dello stato del cluster.


### Scheduling
L'unità schedulabile in Kubernetes è il *Pod*, il quale raggruppa container co-schedulati sullo stesso nodo.
I Pod sono organizzati mediante *labels*, ovvero delle tag key-value che ne forniscono una descrizione per supportare la disciplina di scheduling.
