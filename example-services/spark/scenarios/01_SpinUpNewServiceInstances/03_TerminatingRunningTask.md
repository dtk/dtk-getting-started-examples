## Cancelling a running task
If the user wants to terminate a task while it is running, the user can execute the command 'cancel-task' command in teh context for teh service isnatnce that user wants cancled. Below shows user canceling a task running for service instance 'spark-cluster1' and then checking task status
```
dtk:/service/spark-cluster1>cancel-task
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | cancelled |               | 8.8s     | 18:10:38 26/11/15 | 18:10:47 26/11/15 |
|   1 bigtop_multiservice          | succeeded |               | 0.0s     | 18:10:38 26/11/15 | 18:10:38 26/11/15 |
|     1.1 configure_node           | succeeded | assembly_wide | 0.0s     | 18:10:38 26/11/15 | 18:10:38 26/11/15 |
|   2 bigtop hiera                 | succeeded |               | 1.4s     | 18:10:38 26/11/15 | 18:10:40 26/11/15 |
|     2.1 configure_nodegroup      | succeeded | slaves        | 1.2s     | 18:10:39 26/11/15 | 18:10:40 26/11/15 |
|       2.1.1 configure_node       | succeeded | slaves:1      | 0.9s     | 18:10:39 26/11/15 | 18:10:39 26/11/15 |
|       2.1.2 configure_node       | succeeded | slaves:2      | 0.9s     | 18:10:39 26/11/15 | 18:10:40 26/11/15 |
|     2.2 configure_node           | succeeded | master        | 1.0s     | 18:10:38 26/11/15 | 18:10:39 26/11/15 |
|   3 bigtop_base                  | succeeded |               | 3.7s     | 18:10:40 26/11/15 | 18:10:44 26/11/15 |
|     3.1 configure_nodegroup      | succeeded | slaves        | 3.7s     | 18:10:40 26/11/15 | 18:10:44 26/11/15 |
|       3.1.1 configure_node       | succeeded | slaves:1      | 3.4s     | 18:10:40 26/11/15 | 18:10:43 26/11/15 |
|       3.1.2 configure_node       | succeeded | slaves:2      | 3.3s     | 18:10:40 26/11/15 | 18:10:44 26/11/15 |
|     3.2 configure_node           | succeeded | master        | 3.5s     | 18:10:40 26/11/15 | 18:10:44 26/11/15 |
|   4 namenode                     | cancelled |               | 2.7s     | 18:10:44 26/11/15 | 18:10:47 26/11/15 |
|     4.1 configure_node           | failed    | master        | 3.1s     | 18:10:44 26/11/15 | 18:10:47 26/11/15 |
|   5 if needed leave safemode     |           |               |          |                   |                   |
|     5.1 action                   |           | master        |          |                   |                   |
|   6 namenode smoke test          |           |               |          |                   |                   |
|     6.1 action                   |           | master        |          |                   |                   |
| ...
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
33 rows in set


```
