## Create and deploy a service instance from an assembly
A Service module has one or more 'assemblies', each of which captures one or more services and/or applications and how the service daemons and application components map to one or more nodes. We refer to this node mapping as an 'application topology', which can run the gambit from a single node to a cluster with master and slave nodes to a complex high-availability configuration along with monitoring, security and other support services. In the example service module 'bigtop:spark' there is a single assembly named 'cluster', which has a master/slave topology that runs a Spark and HDFS service.

In the example below an assembly is 'deployed' meaning that its actual execution on EC2 is initiated when the user hits 'deploy'. A user can deploy the same assembly multiple times to deploy multiple copies of the assembly.  It is analogous to in EC2 launching an instance from an image, but in this case the deployed entity can have multiple nodes. This deployed entity is referred to as a 'service instance'. As an alternative to deploying an assembly in a single operation, the user can also first 'stage' the assembly to form a service instance that is not yet launched then set parameters or otherwise customize the service instance before actualLy launching it (see ...)


**Cut-and-paste**

Navigate to 'bigtop:spark'service module and list its assemblies
```
cd /service-module/bigtop:spark
list-assemblies

```
Navigate to the 'cluster' assembly and deploy this cluster as service instance with name 'spark-cluster1'
```
cd assembly/cluster
deploy spark-cluster1

```
Navigate to the service instance context and list the set of service instances, which in this case will show a single service instance that is in 'running' state
```
cd /service
ls

```
**Commands and responses**
```
dtk:/>cd /service-module/bigtop:spark
dtk:/service-module/bigtop:spark>list-assemblies
+------------+---------------+-------+---------------+
| ID         | ASSEMBLY NAME | NODES | DESCRIPTION   |
+------------+---------------+-------+---------------+
| 2147491121 | cluster       | 3     | spark cluster |
+------------+---------------+-------+---------------+
1 row in set


dtk:/service-module/bigtop:spark>cd assembly/cluster
dtk:/service-module/bigtop:spark/assembly/cluster>deploy spark-cluster1
  2147491171
  assembly_instance_name: spark-cluster1
  task_id: 2147491402

dtk:/service-module/bigtop:spark/assembly/cluster>cd /service
dtk:/service>ls
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147491171 | spark-cluster1 | running | executing | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 02:03:51 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
1 row in set

```
## Using task status to follow deployment of service
When a service instance is launched, a task is used to keep track of its execution. The user interaction model is asynchronous meaning the user can be performing other actions in the DTK shell while the task is executing. To check the progress of am excuting task the user can use the 'task-status' command in a service instance context. In this example there is only one service instance 'spark-cluster1', but the DTK user could have simultaneously deployed a set of service instances and then navigate between them to see the status of each

The task status command provides three different user interaction modes that are selected with different command lines options. To see a snapshot of the task progress, the following commands can be issued
```
cd /service/spark-cluster1
task-status
```
A sample result is:
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
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
35 rows in set
```
This shows exceution of task in the midst of execution that is deploying the Spark and HDFS. When an assembly is deployed for the first time in an EC2 environment the first stage creates all the needed nodes and the subsequent stages perform configuration or test actions. The exact steps performed are captured by workflows described in the Service module DSL (see ...)

Anoher mode for task status display is where the client blocks and streams the results as they are produced stage by stage:
```
cd /service/spark-cluster1
task-status m stream
```
A sample results is:
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
```
If 'task-status -m stream' is invoked after steps have actual been executed it will stil show the earlier steps that had executed

The user can also display task status in a mode  similar to that of the Linux top command". This is accomplished with the commands:
```
cd /service/spark-cluster1
task-status --wait
```
This mode is left after the task completes (in either success, failure, or because it was teminated by the user), or the user exits the top-mode by issuing  ^C


## Checking Task Completion
Task completion can be checked in a number of different ways. Using the 'task-status' command the user can determine whether the task is complete. Below is an example of a task that completed in success
```
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | succeeded |               | 318.6s   | 17:16:55 26/11/15 | 17:22:13 26/11/15 |
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
...
```
The top level row 'assembly' converge' indicates the summary status of the task as a whole.
As an alternative, to see the status of all the service instances the user can do a list command at the service level context by issuing the following commands:
```
cd /service
ls

```
The results can look like
```
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147493837 | spark-cluster1 | running | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 17:16:53 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
1 row in set

```
The 'LAST RUN' column shows the status of the last run task. The 'STATUS' column indicates whether the service instance is powered on ('running'), powered off ('stopped'), user terminated ('cancelled') or staged and not yet executed ('pending').
As an example of a scenario where along with 'spark-cluster1' the user  also staged but did not yet execute a second spark cluster 'spark-cluster2'
```
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147493837 | spark-cluster1 | running | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 17:16:53 26/11/15 |
| 2147494146 | spark-cluster2 | pending |           | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 18:03:51 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
```
Since no tasks have been run yet for 'spark-cluster2' the column 'LAST RUN' has no value

