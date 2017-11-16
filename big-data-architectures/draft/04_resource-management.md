# Resource Management

## Mesos
Architettura master-slave.
Paxos per elezione del master con Zookeeper.
Gli slave pubblicano risorse al master, il master le offre ali framework.
Scheduling a due livelli: Mesos offre risorse, il framework accetta le offerte in base al proprio scheduling dei task dei job.
Nota: l'isolamento delle prestazioni ottenuto dai container è peggiore dell'isolamento delle prestaiìzioni ottenuto con le virtual machine.


## YARN
Architettura master-slave.
Scheduling a due livelli: il framework richiede risorse in base al proprio scheduling dei task dei job, YARN le alloca.


## Borg
Sistema di cluster management, proprietario di Google.
Architettura master-slave (slide 76).
Master replicato (5 repliche). L'elezione del master è gestita da Chubby2 con algoritmo di elezione Paxos.
Ogni replica del master fa snapshot, la cui consistenza è mantenuta da Paxos.
Scheduling disaccoppiato dal master, per ridurre la complessità del master.
Un borglet gestisce l'esecuzione dei task sul cluster associato.
Borgmaster fa polling periodico sui borglet per monitorare il loro stato.
Il Fauxmaster è un simulatore del comportamente del Borgmaster. Riesegue i checkpoint. Usato per fare debugging e capacity planning dei job e valutare nuove politiche e algoritmi di scheduling.
Prima di mandare in produzione, si simuka con Fauxmaster.
La scalabilità è garantita da:
* separazione scheduler ddl Borgmaster.
* il meccanismo di polling per hearthbit monitoring è fattao da thread separati.
* le repliche del master non sono semlici repliche ombra, bensì ogni replica si occupa di specifiche funzioni e Paxos viene usato per raggiungere il consenso quando necessario.

Lo scheduling è a due livelli:
* feasibility checking: identificare sottiinsime id macchine per una specifica app.
* scoring: ad pgni macchina è atribuito uno score, secondo criteri specificati dall'utente (es. priotià che minimizzano preemption, bilanciamento del consumo energetico, minimizzare il trasferimento dei dati), e in base a questo score si sceglie la macchina la utilizzare.

Per selezionare la macchina viene utilizzato algoritmo di Bin-Packing. Ci sono molte euristiche per fare bin packing. Le più famose sono best-fit o first-fit o worst-fit. Il bin-packing è un problema NP-hard. L'euristica utilizzata da google non è nota.

Viene fatto caching dei punteggi per velocizzare la fase di scoring. Meglio ussare un punteggio approssimativo ma attendibile cachato, che ricalcolarlo precisamente. Lo score viene calcolato su un sottiinsieme random delle macchine della cella.

Accanto al servizio di naming ci deve essere il servizio di discovery, per capire quale macchina corrisponde ad uno specifico name.




* admission control: viene valutato se il set delle risorse che l'app decide può essere fornito dalla cella oppure se ha una richiesta eccessiva e non va ammesso.
* efficient task-packing: ogni job è diviso in task.
* over-commitment: fa overbooking delle risorse.
* machine sharing: condivisione delle risorse fisiche a disposizione del cluster.
Borg è stato descritto e pubblicato nel 2015, però è stato sviluppato nel 2005.

Un cluster è diviso in celle. Ogni cella è composta da circa 10K nodi con caratteristiche eterogenee.
Una applicazione è un job. Ogni job è composto da task. Ogni task è mappato su un insieme di processi linux eseguiti in un container.
Intuitivamente, possiamo associare un task ad un container. Quindi ogni app è eseguita da più container.

A differenza di Mesos e YARN, ai job è associata una priorità da utilizzare per lo scheduling, che è preemptive.
La quota viene usata per l'admission control.

Il meccanismo di naming è necessario per capire in quale container è eseuito uno specifico task.
Il naming permette la relocation dei task su macchine diverse. Il naming permette una maggiore flessibilità del provisioning.
La convenzione di naming è : nometask.nomejob.nomeutente.nomecella.borg.domain.ttl
Il naming permette il monitoring, fatto di migliaia di metriche di prestazioni.

Un job viene definito come in slide 75.


## Omega
Sistema proprietario di Google.
Derivante da Omega, ma pubblicato prima che fosse pubblicato Borg.
Riprende over.committment da Borg.
Architettura master-slave.
Scheduling a stato condiviso. Non c'è un unico scheduler che dice l'allocazione dei job sulle macchine ma c'èun componente distribuito dello scheduler. Inc aso di decisioni conflittuali tra gli scheduler, questo viene risolto con algoritmo di elezione.
Fanno decidere agli scheduler dei framework, se oi scelgono la stessa risorsa, intervengono per risolvere il conflitto.
Ritengono che l'approccio scheduling di Mesos non sia ottimale perchè perde tempo ad offrire le risorse ai framework.
*Store condiviso ?*


## Kubernetes
Il primo progetto di resource management rilasciato open source da Google.
Riprende acune caratteristiche di Borg e Omega.
Su Kubernetes Google esegue tutte le sue applicazioni.
Tutto in Google è all'onterno dei container.
Stesso sistema di naming e monitoraggio di Borg.
Architettura molto simile a Borg.
Prevede self-healing dei sistemi autonomici per elastic provisionig.
Kubernetes riprende lo scheduling condiviso di Omega.
Ha una infrastruttura container-centric: ovvero le applicazioni viengono deploytate containerizzate.
multi-cloud: ovvero gestisce parallelamente piattaforme cloud di provider diversi.
Slide 83**
specifica dichiaratuva dei requisiti dei container.
A ciascun pod viene assegnato un indirizzo IP univoco, questo permette die vitare di impllementare un DNS, rendondo Kubernetes più flessibile e predisposto ad eseguire framework diversi.
Si va nella direzione dei micrservizi.
Un pod è costituito da più container.
I container di uno stesso pod vengono schedulati sulla stessa macchina. Questo per minimizzare il trasferimento dati.
Da Omega riprende lo store condiviso.
Architettura molto simile a Borg.
Kubernetes può essere eseguito su Mesos.


## Container
Rispetto a VM non hanno il layer di indirezione del hipervisor. Quindi degrado delle prestazioni pressochè nullo.
Minore isolamnto delle risorse rispetto a VM, perchè i container condividono lo stesso SO.
Nelle VM è l'hypervisor a schedulare le risorse delle VM, garantendo isolamente delle risorse.
I container sono vulnerabili ad attacchi sul OS.
copy-on-write sui layer dei container. I layer originali vengono condivisi dai container. Quando un containe rh avisogno di modificare il layer, quello condiviso viene copiato e modificato.
Sul mercato nel 2012, ma Google aveva terorizzato nel 2005 (application oriented shift: datace hter orientati alle app e non alle macchine).
