# Introduzione

La *simulazione discrete-event* è una disciplina che consiste nell'utilizzare tecniche matematiche e computazionali per modellare, simulare e analizzare le performance di un sistema. Questa disciplina permette di prendere decisioni riguardanti il sistema reale, basandosi su esperimenti condotti sul modello che lo simula, piuttosto che sul sistema reale stesso.

Un *modello di simulazione discrete-event* è
* *stocastico:* le variabili di stato sono variabili aleatorie;
* *dinamico:* l'evoluzione delle variabili di stato dipende dal tempo;
* *discrete-event:* lo stato cambia in risposta ad eventi che occorrono in tempo discreto.

Il modello può essere:
* *trace-driven:* la simulazione è guidata da dati precollezionati;
* *next-event:* la simulazione è guidata da dati generati a run-time.

Lo sviluppo di un modello prevede i seguenti step:
* *obiettivi:* definizione degli obiettivi da perseguire; tipicamente, decisioni booleane o numeriche.
* *modello concettuale:* definizione di (i) struttura del sistema, (ii) variabili di stato del modello e (iii) loro relazione con le statistiche da produrre.
* *modello delle specifiche:* modellazione statistica delle variabili che guidano la simulazione.
* *modello computazionale:* design e implementazione del software per l'esecuzione del modello. Il linguaggio può essere general-purpose o un linguaggio di simulazione.
* *verifica:* il modello computazionale deve risultare consistente con il modello delle specifiche.
* *validazione:* il modello computazionale deve risultare consistente con le osservazioni del sistema reale simulato.

## Output Statistics
Le statistiche principali sono:
* *job-averaged:* la medie sono calcolate in base al numero di job.
  * *average interarrival time*
  * *average service time*
  * *average delay*
  * *average wait*
* *time-averaged:* le medie sono calcolate in base al tempo.
  * *jobs in node*
  * *jobs in queue*
  * *jobs in service (utilization)*
