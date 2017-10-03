## Apache Oozie

Oozie is a workflow scheduler, used to manage recurring query to be executed on Hadoop cluster.
A workflow is a DAG (Directed Acyclic Graph), where nodes can be:
* control node: defines the control flow execution path (e.g. start, end, kill, if-then-else, for, while, fork, join);
* action node: triggers the execution of a task;
The workflow can be parametrixed with template variables (e.g. ${inputDir}).

Lo start può essere temporizzato

The workflow is defined with XPDL, that is an extension of XML.

Streaming MapReduce è un progetto streaming per flussi map reduce. Non lo esaminiamo perchè Spark Streaming è più efficiente.
