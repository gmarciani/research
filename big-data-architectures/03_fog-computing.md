# Fog Computing
In uno scenario in cui device interconessi producono flussi continui di dati eterogenei da analizzare in real-time, le soluzioni *Cloud-only* non sono più praticabili, in quanto producono un *bottle-neck ai bordi della rete*.

Il **Fog Computing** (termine coniato da Cisco) si propone come soluzione a questo scenario e rappresenterà presto lo scenario riferimento per sistemi Big Data.

Il Fog Computing è un'architettura di sistema orizzontale che distribuisce i servizi di *computing*, *storage* e *networking* laddove i dati vengono prodotti, creando così una soluzione di continuità, detta **Cloud-to-Thing Continuum** (quindi non solo ai bordi della rete), realizzata distribuendo micro data center, detti **Fog Node**, ai bordi della rete (non solo).

Il Fog Computing può essere dunque visto come un'estensione del Cloud Computing tradizionale in cui l'architettura Cloud viene ulteriormente distribuita, in modo tale da soddisfare i requisiti di latenza e scalabilità delle *applicazioni data-intensive e latency-sensitive*.

Gli scenari applicativi più rappresentativi del Fog Computing sono *IoT* e *AI*, come smart city, smart energy grid, smart transportation e industry 4.0.


## OpenFog Consortium
L'OpenFog Consortium è un consorzio industriale internazionale che raccoglie compagnie high-tech e università con lo scopo di standardizzare e promuovere il Fog Computing.

È stato fondato da Cisco, Intel, Microsoft, Dell, ARM e Princeton University nel 2015.

Il consorzio ha prodotto la prima *architettura di riferimento del Fog Computing* nel Febbraio 2017


## Architettura
L'architettura di riferimento del Fog Computing è stata definita per la prima volta dall'OpenFog Consortium nel Febbraio 2017.

Lo scopo dell'architettura è fornire un riferimento per la progettazione di interfacce *Client2Fog*, *Fog2Fog* e *Fog2Cloud*.

I principi che hanno guidato la definizione dell'architettura, detti **Fog Computing Pillars**, sono:

* **security:** meccanismi di sicurezza hardware e software all'interno del singolo Fog Node e nelle interfacce del Fog.
* **scalability:** scalabilità orizzontale e verticale.
* **openness:** componibilità, interoperabilità e localizzabilità.
* **RAS:** reliability, availability e serviceability (i.e., configurazione, deployment, orchestration e manutenzione).
* **agility:** responsiveness al volume dei dati e predisposizione all'innovazione.
* **autonomy:** autonomia in termini di resource discovery, orchestration e sicurezza al fine di minimizzare i costi.
* **hierarchy:** un cluster Fog è costituito dagli strati:
  * **device:** sensori e attuatori.
  * **control:** monitoring e controllo dei device.
  * **operational support:** gestione dello streaming dei dati.
  * **business support:** aggregazione analytics.
* **programmability:** adaptive deployment delle applicazioni e Fog Node programmabili.


## SCALE
I vantaggi del Fog Computing sono sintetizzati nel **modello SCALE**:

* **security:** sicurezza delle interfacce Fog2Fog e Fog2Cloud.
* **cognition:** maggiore awarness degli obiettivi delle applicazioni client.
* **agility:** scalabilità orizzontale/verticale e predisposizione all'innovazione.
* **latency:** minimizzazione della latenza.
* **efficiency:** resource management a grana fine con partizionamento dinamico delle risorse.


## Fog vs Edge
Il Fog Computing viene spesso associato al **Edge Computing**.

Alcune comunità scientifiche li vedono come due facce della stessa medaglia: il Fog Computing ha a che fare con l'infrastruttura e i servizi, l'Edge Computing ha a che fare con i device.

L'OpenFog Consortium definisce una distinzione più netta:

* **Fog Computing:** coopera con il Cloud Computing, fornendo servizi di computazione, storage, networking e controllo, spaziando su tutti i livelli di rete.
* **Edge Computing:** esclude il Cloud Computing, fornendo solo servizi di computazione, spaziando sui soli livelli di rete più alti.
