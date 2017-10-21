# Big Data
Con il termine Big Data indichiamo un *fenomeno di produzione di dati il cui processamento, volto all'estrazione di valore informativo, sfugge alle tecnologie tradizionali*.

Molte definizioni sono state date per descrivere questo fenomeno, al fine di definirne le dimensioni in cui individuarlo.

* *Big data exceeds the reach of commonly used hardware environments and software tools to capture, manage, and process it within a tolerable elapsed time for its user population.* -- Teradata Magazine article, 2011.

* *Big data refers to data sets whose size is beyond the ability of typical database software tools to capture, store, manage and analyze.* -- The McKinsey Global Institute, 2012.

* *Big data is a term for data sets that are so large or complex that traditional data processing application softwares are inadequate to deal with them.* -- Wikipedia, 2017.

* *Big data is high volume, high velocity, and/or high variety information assets that require new forms of processing to enable enhanced decision making, insight discovery and process optimization.* -- Gartner, 2012.


## Motivazioni
I motivi principali per cui oggi si parla di Big Data sono:

* i dati sono nativamente digitali;
* il volume dei dati generati ha una crescita annua del 40%;
* la capacità computazionale è aumentata;
* l'hardware è meno costoso;
* le compagnie sono sempre più interessate ai Big Data (il 76% delle compagnie si dichiara Big Data nel 2016).
* gli investimenti su tecnologie Big Data sono aumentati (130B$ investiti nel 2016).


## Modello 7V
Il **modello 7V** intende individuare le dimensioni che permettono di identificare il fenomeno Big Data.

* **volume:** la dimensione del flusso dei dati è così grande da rendere *impossibile l'approccio store&process tradizionale*.
* **variety:** i dati sono eterogenei in termini di *dominio, formato e grado di strutturazione*.
* **velocity:** i dati vengono *prodotti velocemente* e devono essere *analizzati velocemente*.
* **value:** il dataset ha un *valore informativo* di rilevanza strategica per il business.
* **veracity:** *accuratezza e autenticità* dei dati sono *incerte*.
* **variability:** il flusso di dati presenta *spike, burst e irregolarità*.
* **visualization:** il flusso di dati deve essere *rappresentato graficamente per poter essere acquisito efficacemente dall'essere umano* (il nostro cervello processa le immagini 60000 volte più velocemente del testo).

Nel 2012, il modello di riferimento era il **Modello 3V** chee considerava solamente *volume, velocity e variety*.
Il modello è stato successivamente esteso: per questo vi si fa spesso riferimento con il termine **Modello (3+n)V**.


## Stack Big Data
Le tecnologie Big Data possono essere collocate all'interno dello **Stack Big Data**, i cui layer sono:

* **resource management:** responsabile della gestione delle risorse di un *cluster condiviso da più framework*.
* **data storage:** responsabile della persistenza dei dati secondo modelli *NoSQL e NewSQL*.
* **data processing:** responsabile del processamento dei dati secondo paradigmi *Batch Processing* e *Data Stream Processing*.
* **high-level interfaces:** responsabile della *esplorazione e rappresentazione dei dati*.
* **support/integration:** responsabile delle attività di supporto, quali *data ingestion, data extraction e data transportation*.


## Processo Big Data
La gestione dei Big Data è un'attività che segue il seguente *processo iterativo*:

* **acquisition:** selezione delle sorgenti, filtraggio dei dati e generazione dei metadati.
* **extraction:** trasformazione dei dati e gestione degli errori.
* **integration:** standardizzazione, mapping e conflict management.
* **analysis:** esplorazione dei dati mediante tecniche di data mining, machine learning e tecniche di visualizzazione.
* **interpretation:** estrazione di conoscenza dai dati mediante identificazione di pattern di interesse.
* **decision:** formulazione di una strategia di dominio e CI/CD del processo.


## Challenges
Le sfide più importanti in ambito Big Data riguardano le **timing performance**, in quanto *il flusso dei dati cresce ad un tasso maggiore degli avanzamenti tecnologici per il loro processamento*.

Gli approcci usati per garantire timing performance che soddisfino i *vincoli QoS stringenti* previsti sono:

* *distribuzione dell'architettura* con *scaling orizzontale ed elastico*.
* *distribuzione della computazione* con modello di memoria *shared-nothing*.
* *replicazione delle risorse* per garantire *fault-tolerance* e *consistenza finale*.


## Esempi applicativi
Le tecnologie Big Data possono essere impiegate in molteplici domini e scenari applicativi.
Gli esempi più notevoli sono:

* **finanza:** real-time forecasting dei trend di mercato.
* **medicina:** tracking di epidemie, diagnosi di disturbi genetici.
* **sicurezza:** fraud detection, DDOS attack detection, behavioural pattern recognition.
* **smart city:** traffic management, energy grid forecasting.
* **marketing:** real-time sentiment analysis, personalized advertising.
