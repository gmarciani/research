# Big Data
Molte definizioni sono state date per il termine *"Big Data"*:

* *Big data exceeds the reach of commonly used hardware environments and software tools to capture, manage, and process it within a tolerable elapsed time for its user population.* -- Teradata Magazine article, 2011.

* *Big data refers to data sets whose size is beyond the ability of typical database software tools to capture, store, manage and analyze.* -- The McKinsey Global Institute, 2012.

* *Big data is a term for data sets that are so large or complex that traditional data processing application softwares are inadequate to deal with them.* -- Wikipedia, 2017.

* *Big data is high volume, high velocity, and/or high variety information assets that require new forms of processing to enable enhanced decision making, insight discovery and process optimization.* -- Gartner, 2012.

Volendo sintentizzare, indichiamo con Big Data un fenomeno di produzione di dati il cui processamento, volto all'estrazione di valore informativo, sfugge alle tecnologie tradizionali.


## Modello 7V
Il **modello 7V** intende individuare le dimensioni che permettono di identificare lo scenario Big Data.

* **volume:** la dimensione del flusso dei dati è così grande da rendere impossibile l'approccio store&process.
* **variety:** i dati sono eterogenei in termini di dominio, formato e grado di strutturazione.
* **velocity:** i dati vengono prodotti velocemente e devono essere analizzati velocemente.
* **value:** il dataset ha un valore informativo di rilevanza strategica per il business, potendo dunque creare un vantaggio competitivo.
* **veracity:** l'accuratezza e l'autenticità dei dati sono incerte.
* **variability:** il flusso di dati presenta picchi.
* **visualization:** il flusso di dati deve essere rappresentato graficamente per poter essere acquisito efficacemente dall'essere umano (il nostro cervello processa le immagini 60000 volte più velocemente del testo).

Nel 2012, il modello di riferimento era il **modello 3V**: value, variety, velocity.
Il modello è stato successivamente esteso: per questo vi si fa spesso riferimento con il termine **modello (3+n)V**.


## Motivazioni
I motivi principali per cui oggi si parla di Big Data sono:

* i dati sono nativamente digitali;
* il volume dei dati generati ha una crescita annua del 40%;
* la capacità computazionale è aumentata;
* l'hardware è meno costoso;
* le compagnie sono sempre più interessate ai Big Data (il 76% delle compagnie si dichiara Big Data nel 2016).
* gli investimenti su tecnologie Big Data sono aumentati (130B$ investiti nel 2016).


## Stack Big Data
Le tecnologie Big Data possono essere collocate all'interno dell **Stack Big Data**, i cui layer sono:

* **resource management**
* **data storage**
* **data processing**
* **high-level interfaces**
* **support/integration**


## Big Data Process
La gestione dei Big Data segue il seguente processo iterativo:

* **acquisition:** selezione delle sorgenti, filtraggio dei dati e generazione dei metadati.
* **extraction:** trasformazione dei dati e gestione degli errori.
* **integration:** standardizzazione, mapping, conflict management e reconciliation.
* **analysis:** esplorazione dei dati mediante data mining, machine learning e tecniche di visualizzazione.
* **interpretation:** estrazione di conoscenza mediante identificazione di pattern di interesse.
* **decision:** formulazione di una strategia di dominio e CI/CD del processo.


## Challenges
Le sfide più importanti in ambito Big Data riguardano le **timing performance**, in quanto il flusso dei dati cresce ad un tasso maggiore degli avanzamenti tecnologici per il loro processamento.

Gli approcci usati per garantire timing performance all'avanguardia sono:

* *architettura distribuita* con *scaling orizzontale ed elastico*.
* *computazionale distribuita* con modello di memoria *shared-nothing*.
* *replicazione delle risorse* per garantire *fault-tolerance* e *consistenza finale*.


## Esempi applicativi
Alcuni notevoli esempi di applicazioni Big Data sono i seguenti:

* **finanza:** real-time forecasting dei trend di mercato.
* **medicina:** tracking di epidemie, diagnosi di disturbi genetici.
* **sicurezza:** fraud detection, DDOS attack detection, behavioural pattern recognition.
* **smart city:** traffic management, energy grid forecasting.
* **marketing:** real-time sentiment analysis, personalized advertising.
