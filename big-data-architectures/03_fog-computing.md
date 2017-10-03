# Fog Computing

In uno scenario in cui device interconessi producono flussi continui di dati da analizzare in real-time, le soluzioni cloud-only non sono più praticabili, in quanto producono un bottle-neck ai bordi della rete.

Il Fog Computing si propone come soluzione a questo scenario.

Il Fog Computing è un'architettura di sistema orizzontale che distribuisce i servizi di computazione, storage e networking laddove i dati vengono prodotti secondo una soluzione di continuità, detta "cloud-to-thing continuum" (quindi non solo ai bordi della rete).

Può essere visto come un'estensione del Cloud Computing tradizionale in cui l'architettura Cloud viene ulteriormente distribuita e implementata in più livelli di rete.

Mantiene dunque i benefici del Cloud Computing, soddisfacendo i requisiti di latenza e scalabilità delle odierne e future applicazioni latency-sensitive.

Praticamente, consiste nella distribuzione di micro data center, detti Fog Node, ai bordi della rete ( non solo).

Il Fog Computing rappresenterà presto lo scenario riferimento per i sistemi e le tecnologie di Big Data.


## OpenFog Consortium
L'OpenFog Consortium è un consorzio industriale internazionale che raccoglie compagnie high-tech e università con lo scopo di standardizzare e promuovere il Fog Computing.

È stato fondato da Cisco, Intel, Microsoft, Dell, ARM e Princeton University nel 2015, producendo nel Febbraio 2017 la prima architettura di riferimento del Fog Computing.


## Architettura
L'architettura di riferimento del Fog Computing è stata definita per la prima volta dall'OpenFog Consortium nel Febbraio 2017.

Lo scopo dell'architettura è fornire un riferimento per la progettazione di interfacce Fog2Fog e Fog2Cloud.

I principi che hanno guidato la definizione dell'architettura sono:
* **security:** meccanismi di sicurezza hardware e software all'interno del singolo fog node e nelle interazioni Client2Fog, Fog2Fog, Fog2Cloud.
* **scalability:** scalabilità orizzontale e verticale in termini di capacità di rete, hardware dei fog node, applicazioni, sicurezza e gestione.
* **openness:** interoperabilità, componibilità, comunicabilità, localizzabilità.
* **autonomy:** autonomia in termini di resource discovery, orchestration e sicurezza al fine di minimizzare i costi.
* **RAS:** affidabilità (reliability), disponibilità (availability), servibilità (serviceability, ovvero installazione, configurazione, deployment, orchestration e manutenzione).
* **agility:** responsiveness al volume dei dati.
* **hierarchy:** un cluster Fog è costituito dagli strati di (i) *device* (sensori e attuatori), (ii) *controllo* (monitoring e controllo dei device), (iii) *operational support* (gestione dello streaming dei dati) e (iv) *business support* (aggregazione analytics).
* **programmability:** adaptive deployment delle applicazioni, fog node programmabili.


## SCALE
I vantaggi del Fog Computing sono sintetizzati nel **modello SCALE**:
* **security:** sicurezza delle interfacce Fog2Fog e Fog2Cloud.
* **cognition:** maggiore awarness degli obiettivi delle applicazioni client.
* **agility:** scalabilità orizzontale e verticale, predisposizione all'innovazione.
* **latency:** minimizzazione della latenza per il real-time processing.
* **efficiency:** resource management a grana fine con partizionamento dinamico delle risorse.


## Fog/Edge
Il Fog Comouting viene spesso associato all'Edge Computing.

Alcune comunità scientifiche li vedono come due facce della stessa medaglia: il Fog Computing ha a che fare con l'infrastruttura e i servizi, l'Edge Computing ha a che fare con i device.

L'OpenFog Consortium definisce una distinzione più netta: il Fog Computing coopera con il Cloud Computing, fornendo servizi di computazione, storage, networking e controllo, spaziando su tutti i livelli di ret; mentre l'Edge Computing esclude il Cloud Computing, fornendo solo servizi di computazione, spaziando sui soli livelli di rete più alti.


## Esempi applicativi
I più notevoli esempi applicativi del Fog Computing riguardano IoT e AI, come smart city, smart energy grid, smart transportation e industry 4.0.
