## Using task status to follow deployment of service
When a service instance is launched, a task is used to keep track of its execution. The user interaction model is asynchronous meaning the user can be performing othera actions in the DTK shell while the task is executing. To check the progress of execution the user can use the 'task-status' command in a service instance context. In this example there is only one service instance 'spark-cluster1', but the DTK user could have simultaneously deployed a set of service instances and then navigate between them to see the status of each

The task status command provides three different user interaction modes that are selected with different command lines options. These are
* See a snapshot of the task progress
```
task-status
```
* Put the DTK shell in Linux top-like mode to advance the progress; this mode is left after the task completes in either success, failure, or because it was teminated by the user or the user in the wants switch out of top mode using ^D
```
task-status --wait
```
* Have the client block and stream the results as they are produced stage by stage
```
task-status -m stream
```

So as an example, the user can navigate to the service instance 'spark-cluster1' and then see a snaphsot of progress using the commands:
```
cd /service/spark-cluster1
task-status
```
The result can look like
```
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
This shows the deployment of the cluster, which is providing both Spark and HDFS services in the midst of execution. When an assembly is deployed for the first time in an EC2 environment the first stage creates all the needed nodes and the subsequent stages perform configuration or test actions. The exact steps performed are captured by workflows described in the Service module DSL (see ...)

An example of using the stream format is 
```
dtk:/service/spark-cluster1>task-status -m stream
========================= 2015-11-26 17:16:55 +0000 start 'assembly_converge' =========================


============================================================
STAGE 1: create_nodes_stage
TIME START: 2015-11-26 17:16:55 +0000
OPERATION: CreateNodes
  master
  slaves:1
  slaves:2
STATUS: succeeded
DURATION: 83.8s
------------------------------------------------------------

============================================================
STAGE 2: bigtop_multiservice
TIME START: 2015-11-26 17:18:19 +0000
COMPONENT: assembly_wide/bigtop_multiservice
STATUS: succeeded
DURATION: 0.0s
------------------------------------------------------------

============================================================
STAGE 3: bigtop hiera
TIME START: 2015-11-26 17:18:29 +0000
COMPONENTS:
  node-group:slaves/bigtop_multiservice::hiera
  master/bigtop_multiservice::hiera
STATUS: succeeded
DURATION: 5.4s
------------------------------------------------------------

============================================================
STAGE 4: bigtop_base
TIME START: 2015-11-26 17:18:35 +0000
COMPONENTS:
  node-group:slaves/bigtop_base
  master/bigtop_base
STATUS: succeeded
DURATION: 5.8s
------------------------------------------------------------

============================================================
STAGE 5: namenode
TIME START: 2015-11-26 17:18:41 +0000
COMPONENT: master/hadoop::namenode
STATUS: succeeded
DURATION: 45.5s
------------------------------------------------------------

============================================================
STAGE 6: if needed leave safemode
TIME START: 2015-11-26 17:19:27 +0000
ACTION: master/hadoop::namenode.leave_safemode
STATUS: succeeded
DURATION: 3.5s
RESULTS:

NODE: master
RUN: su hdfs -c 'hdfs dfsadmin -safemode leave' (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 7: namenode smoke test
TIME START: 2015-11-26 17:19:30 +0000
ACTION: master/hadoop::namenode.smoke_test
STATUS: succeeded
DURATION: 2.2s
RESULTS:

NODE: master
RUN: echo "namenode port=8020" (syscall)
RETURN CODE: 0
STDOUT:
  namenode port=8020
--
RUN: netstat -nltp | grep 8020 (syscall)
RETURN CODE: 0
STDOUT:
  tcp        0      0 10.90.0.238:8020            0.0.0.0:*                   LISTEN      3637/java
--
RUN: su hdfs -c "hdfs dfsadmin -safemode get" | grep OFF (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 8: datanodes
TIME START: 2015-11-26 17:19:33 +0000
COMPONENTS:
  node-group:slaves/hadoop::common_hdfs
  node-group:slaves/hadoop::datanode
STATUS: succeeded
DURATION: 33.0s
------------------------------------------------------------
...
```
If 'task-status -m stream' is invoked after steps have actual been executed it will stil show the earlier steps that had executed


