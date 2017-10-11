# Big Data
Molte definizioni sono state date per il termine "Big Data":

* Big data exceeds the reach of commonly used hardware environments and software tools to capture, manage, and process it within a tolerable elapsed time for its user population. -- Teradata Magazine article, 2011.
* Big data refers to data sets whose size is beyond the ability of typical database software tools to capture, store, manage and analyze. -- The McKinsey Global Institute, 2012.
* Big data is a term for data sets that are so large or complex that traditional data processing application softwares are inadequate to deal with them. -- Wikipedia, 2017.
* Big data is high volume, high velocity, and/or high variety information assets that require new forms of processing to enable enhanced decision making, insight discovery and process optimization. -- Gartner, 2012.

I Big Data hanno motivato l'affermazione dei concetti: Extract-Load-Transform (ELT), data lake, NoSQL.

## Modello 7V
Con il termine Big Data si indica uno scenario in cui il dataset risponde al **modello 7V**:
* **volume:** la dimensione del flusso dei dati è così grande da rendere impossibile l'approccio store&process.
* **variety:** i dati sono eterogenei in termini di dominio, formato e grado di strutturazione.
* **velocity:** i dati vengono prodotti velocemente e devono essere analizzati velocemente.
* **value:** il dataset ha un valore informativo di rilevanza strategica per il business, potendo dunque creare un vantaggio competitivo.
* **veracity:** incertezza dell'accuratezza e della autenticità dei dati.
* **variability:** il flusso di dati presenta picchi.
* **visualization:** il flusso di dati deve essere rappresentato graficamente (il nostro cervello processa le immagini 60000 volte più velocemente del testo).

Nel 2012, il modello di riferimento era il **modello 3V**: value, variety, velocity. Il modello è stato successivamente esteso: per questo vi si fa riferimento con il termine **modello (3+n)V**.


## Motivazioni
I motivi per cui oggi si parla di Big Data sono i seguenti:
* i dati sono nativamente digitali.
* i dati sono generati con crescita annua del 40%.
* diminuzione del costo hardware.
* aumento della capacità computazionale.
* interesse delle compagnie (76% delle compagnie interessate ai Big Data nel 2016).
* aumento degli investimenti su tecnologie applicabili ai Big Data (130B$ investiti nel 2016).


## Stack Big Data
Lo stack big data è cosituita dai seguenti layer (dal più basso al più alto):
* **resource management**
* **data storage**
* **data processing**
* **high-level interfaces**
* **support/integration** (interconnette tutti i layer)


## Big Data Process
La gestione dei Big Data segue il seguente processo iterativo:
* **acquisition:** selezione delle sorgenti, filtraggio dei dati, generazione dei metadati.
* **extraction:** normalizzazione, correzione, aggregazione, trasformazione, gestione degli errori.
* **integration:** standardizzazione, conflict management, reconciliation, mapping.
* **analysis:** esplorazione, data mining, machine learning, visualizzazione.
* **interpretation:** conoscenza del dominio, identificazione dei pattern di interesse.
* **decision:** formulazione strategia, CI/CD del processo.


## Challenges
Le sfide più importanti in ambito Big Data riguardano le timing performance, in quanto il flusso dei dati cresce ad un tasso maggiore degli avanzamenti tecnologici per il loro processamento.

Gli approcci usati per garantire timing performance all'avanguardia sono:
* architettura distribuita che scali orizzontalmente ed elasticamente.
* computazionale distribuita basata su modello di memoria shared-nothing.
* replicazione delle risorse per garantire fault-tolerance e consistenza finale.


## Esempi applicativi
Alcuni notevoli esempi di applicazioni Big Data sono i seguenti:
* finanza: real-time forecasting dei trend di mercato.
* medicina: tracking di epidemie, diagnosi di disturbi genetici.
* sicurezza: fraud detection, DDOS attack detection, behavioural pattern recognition.
* smart city: traffic management, energy grid forecasting.
* marketing: real-time sentiment analysis, personalized advertising.
