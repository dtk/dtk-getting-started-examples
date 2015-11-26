## Using task status to follow deployment of service
When a service instance is task is launaced that is used to keep track of its execution. The intercation model is asynchrnous maning the user can be performing other actions in teh DTK shell while teh task is executing. To check the progress of execution the user can use the 'task_status' command in a service instance context. In this example there is only one service isntance 'spark-cluster1', but other ways that the DTK can be used is to simultaneously deploy a set of service isntances and then navigate between them to see teh status of each

The task status command provides three different user interaction modes that are selected with different command lines options. These are
* See a snapshot of the task progress
```
task-status
```
* Put the DTK shell in Linux top-like mode to advance the progress; this mode is left after the task compltes in either success, failure, or because it was teminated by the user or the user in the wants switch out of top mode using ^D
```
task-status --wait
```
* Have the client block and stream the results as they are produced stage by stage
```
task-status -m stream
```


A Service module has one or more 'assemblies', each of which captures one or more services and/or applications and how the service daemons and application components map to one or more nodes. We refer to this node mapping as an application topology, which can run the gambit from a single node to a cluster with master and slave nodes to a complex high-availability configuration along with monitoring, security and other support services. In the example service module 'bigtop:spark' there is a single assembly named 'cluster', which has a master/slave topology supporting a Spark and HDFS service.

In the example below an assembly is 'deployed' meaning that its actual execution on EC2 is initiated when the user hits 'deploy'. A user can deploy the same assembly multiple times to deploy multiple copies of the assembly.  It is analogous to in EC2 launching an instance from an image, but in this case the deployed entity can have multiple nodes. This deployed entity is referred to as a 'service instance'. As an alternative to deploying an assembly in a single operation, the user can also first 'stage' the assembly to form a service instance that is not yet launched then set parameters or otherwise customize the service instance before actual launching it (see ...)


**Cut-and-paste**

Navigate to 'bigtop:spark'service module and list its assemblies
```
cd /service-module/bigtop:spark
list-assemblies

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
