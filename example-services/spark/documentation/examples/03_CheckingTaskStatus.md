## Using task status to follow deployment of service
In order to deploy services, service modules must first be intsalled from the DTK Catalog manager. Below shows intsllation of a Service Module for deployiong spark clusters

cut-and-paste
```
cd service-module
install bigtop:spark
```
with outputs
```
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | executing |               |          | 17:16:55 26/11/15 |                   |
|   1 create_nodes_stage           | succeeded |               | 83.8s    | 17:16:55 26/11/15 | 17:18:18 26/11/15 |
|     1.1 create_node              | succeeded | master        | 82.0s    | 17:16:55 26/11/15 | 17:18:17 26/11/15 |
|     1.2 create_node              | succeeded | slaves:1      | 83.8s    | 17:16:55 26/11/15 | 17:18:18 26/11/15 |
|     1.3 create_node              | succeeded | slaves:2      | 82.8s    | 17:16:55 26/11/15 | 17:18:17 26/11/15 |
|   2 bigtop_multiservice          | succeeded |               | 0.0s     | 17:18:19 26/11/15 | 17:18:19 26/11/15 |
|     2.1 configure_node           | succeeded | assembly_wide | 0.0s     | 17:18:19 26/11/15 | 17:18:19 26/11/15 |
|   3 bigtop hiera                 | succeeded |               | 5.4s     | 17:18:29 26/11/15 | 17:18:35 26/11/15 |
|     3.1 configure_nodegroup      | succeeded | slaves        | 5.3s     | 17:18:29 26/11/15 | 17:18:35 26/11/15 |
|       3.1.1 configure_node       | succeeded | slaves:1      | 3.4s     | 17:18:29 26/11/15 | 17:18:33 26/11/15 |
|       3.1.2 configure_node       | succeeded | slaves:2      | 3.1s     | 17:18:31 26/11/15 | 17:18:35 26/11/15 |
|     3.2 configure_node           | succeeded | master        | 3.3s     | 17:18:29 26/11/15 | 17:18:32 26/11/15 |
|   4 bigtop_base                  | succeeded |               | 5.8s     | 17:18:35 26/11/15 | 17:18:41 26/11/15 |
|     4.1 configure_nodegroup      | succeeded | slaves        | 5.5s     | 17:18:35 26/11/15 | 17:18:41 26/11/15 |
|       4.1.1 configure_node       | succeeded | slaves:1      | 5.3s     | 17:18:35 26/11/15 | 17:18:40 26/11/15 |
|       4.1.2 configure_node       | succeeded | slaves:2      | 5.3s     | 17:18:35 26/11/15 | 17:18:41 26/11/15 |
|     4.2 configure_node           | succeeded | master        | 5.3s     | 17:18:35 26/11/15 | 17:18:40 26/11/15 |
|   5 namenode                     | executing |               |          | 17:18:41 26/11/15 |                   |
|     5.1 configure_node           | executing | master        |          | 17:18:41 26/11/15 |                   |
|   6 if needed leave safemode     |           |               |          |                   |                   |
|     6.1 action                   |           | master        |          |                   |                   |
|   7 namenode smoke test          |           |               |          |                   |                   |
|     7.1 action                   |           | master        |          |                   |                   |
|   8 datanodes                    |           |               |          |                   |                   |
|     8.1 configure_nodegroup      |           | slaves        |          |                   |                   |
|       8.1.1 configure_node       |           | slaves:1      |          |                   |                   |
|       8.1.2 configure_node       |           | slaves:2      |          |                   |                   |
|   9 hdfs directories for spark   |           |               |          |                   |                   |
|     9.1 configure_node           |           | master        |          |                   |                   |
|   10 spark master                |           |               |          |                   |                   |
|     10.1 configure_node          |           | master        |          |                   |                   |
|   11 spark workers               |           |               |          |                   |                   |
|     11.1 configure_nodegroup     |           | slaves        |          |                   |                   |
|       11.1.1 configure_node      |           | slaves:1      |          |                   |                   |
|       11.1.2 configure_node      |           | slaves:2      |          |                   |                   |
|   12 component gitarchive[mar01] |           |               |          |                   |                   |
|     12.1 configure_node          |           | master        |          |                   |                   |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
37 rows in set
```
