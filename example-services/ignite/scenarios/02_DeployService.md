## Create annd deploy a service instance from an assembly
```
dtk:/>cd service-module
dtk:/service-module>cd bigtop:ignite
assembly  remotes
dtk:/service-module/bigtop:ignite>cd assembly/cluster
dtk:/service-module/bigtop:ignite/assembly/cluster>deploy ignite-cluster1
  2147495590
  assembly_instance_name: ignite-cluster1
  task_id: 2147495877
```  
```
dtk:/service-module/bigtop:ignite/assembly/cluster>cd /service/ignite-cluster1
dtk:/service/ignite-cluster1>task-status
+-------------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                           | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+-------------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                   | executing |               |          | 17:15:58 27/11/15 |                   |
|   1 create_nodes_stage              | succeeded |               | 87.0s    | 17:15:57 27/11/15 | 17:17:24 27/11/15 |
|     1.1 create_node                 | succeeded | master        | 76.2s    | 17:15:57 27/11/15 | 17:17:14 27/11/15 |
|     1.2 create_node                 | succeeded | workers:1     | 86.9s    | 17:15:58 27/11/15 | 17:17:24 27/11/15 |
|     1.3 create_node                 | succeeded | workers:2     | 79.9s    | 17:15:58 27/11/15 | 17:17:17 27/11/15 |
|   2 bigtop_multiservice             | succeeded |               | 0.0s     | 17:17:25 27/11/15 | 17:17:25 27/11/15 |
|     2.1 configure_node              | succeeded | assembly_wide | 0.0s     | 17:17:25 27/11/15 | 17:17:25 27/11/15 |
|   3 bigtop hiera                    | succeeded |               | 5.3s     | 17:17:35 27/11/15 | 17:17:41 27/11/15 |
|     3.1 configure_nodegroup         | succeeded | workers       | 5.3s     | 17:17:35 27/11/15 | 17:17:41 27/11/15 |
|       3.1.1 configure_node          | succeeded | workers:1     | 4.0s     | 17:17:37 27/11/15 | 17:17:41 27/11/15 |
|       3.1.2 configure_node          | succeeded | workers:2     | 3.8s     | 17:17:35 27/11/15 | 17:17:39 27/11/15 |
|     3.2 configure_node              | succeeded | master        | 3.1s     | 17:17:35 27/11/15 | 17:17:38 27/11/15 |
|   4 bigtop_base                     | succeeded |               | 19.8s    | 17:17:41 27/11/15 | 17:18:01 27/11/15 |
|     4.1 configure_nodegroup         | succeeded | workers       | 19.6s    | 17:17:41 27/11/15 | 17:18:01 27/11/15 |
|       4.1.1 configure_node          | succeeded | workers:1     | 16.4s    | 17:17:41 27/11/15 | 17:17:58 27/11/15 |
|       4.1.2 configure_node          | succeeded | workers:2     | 19.6s    | 17:17:41 27/11/15 | 17:18:01 27/11/15 |
|     4.2 configure_node              | succeeded | master        | 16.8s    | 17:17:41 27/11/15 | 17:17:58 27/11/15 |
|   5 component ignite::cluster       | succeeded |               | 0.1s     | 17:18:01 27/11/15 | 17:18:01 27/11/15 |
|     5.1 configure_node              | succeeded | assembly_wide | 0.1s     | 17:18:01 27/11/15 | 17:18:01 27/11/15 |
|   6 ignite install and configure    | succeeded |               | 95.9s    | 17:18:01 27/11/15 | 17:19:37 27/11/15 |
|     6.1 configure_nodegroup         | succeeded | workers       | 89.0s    | 17:18:02 27/11/15 | 17:19:31 27/11/15 |
|       6.1.1 configure_node          | succeeded | workers:1     | 68.3s    | 17:18:02 27/11/15 | 17:19:10 27/11/15 |
|       6.1.2 configure_node          | succeeded | workers:2     | 88.9s    | 17:18:02 27/11/15 | 17:19:31 27/11/15 |
|     6.2 configure_node              | succeeded | master        | 95.9s    | 17:18:01 27/11/15 | 17:19:37 27/11/15 |
|   7 start ignite on seed            | succeeded |               | 3.4s     | 17:19:38 27/11/15 | 17:19:41 27/11/15 |
|     7.1 action                      | succeeded | master        | 3.4s     | 17:19:38 27/11/15 | 17:19:41 27/11/15 |
|   8 start ignite on all other nodes | succeeded |               | 3.6s     | 17:19:41 27/11/15 | 17:19:45 27/11/15 |
|     8.1 nodegroup actions           | succeeded | workers       | 3.6s     | 17:19:41 27/11/15 | 17:19:45 27/11/15 |
|       8.1.1 action                  | succeeded | workers:1     | 3.6s     | 17:19:41 27/11/15 | 17:19:45 27/11/15 |
|       8.1.2 action                  | succeeded | workers:2     | 3.4s     | 17:19:41 27/11/15 | 17:19:45 27/11/15 |
|   9 namenode                        | succeeded |               | 30.0s    | 17:19:45 27/11/15 | 17:20:15 27/11/15 |
|     9.1 configure_node              | succeeded | master        | 30.0s    | 17:19:45 27/11/15 | 17:20:15 27/11/15 |
|   10 if needed leave safemode       | succeeded |               | 2.3s     | 17:20:15 27/11/15 | 17:20:18 27/11/15 |
|     10.1 action                     | succeeded | master        | 2.3s     | 17:20:15 27/11/15 | 17:20:18 27/11/15 |
|   11 namenode smoke test            | succeeded |               | 2.1s     | 17:20:18 27/11/15 | 17:20:20 27/11/15 |
|     11.1 action                     | succeeded | master        | 2.1s     | 17:20:18 27/11/15 | 17:20:20 27/11/15 |
|   12 datanodes                      | succeeded |               | 30.1s    | 17:20:21 27/11/15 | 17:20:51 27/11/15 |
|     12.1 configure_nodegroup        | succeeded | workers       | 30.1s    | 17:20:20 27/11/15 | 17:20:51 27/11/15 |
|       12.1.1 configure_node         | succeeded | workers:1     | 29.9s    | 17:20:20 27/11/15 | 17:20:50 27/11/15 |
|       12.1.2 configure_node         | succeeded | workers:2     | 30.0s    | 17:20:21 27/11/15 | 17:20:51 27/11/15 |
|   13 hdfs directories for spark     | succeeded |               | 6.9s     | 17:20:51 27/11/15 | 17:20:58 27/11/15 |
|     13.1 configure_node             | succeeded | master        | 6.9s     | 17:20:51 27/11/15 | 17:20:58 27/11/15 |
|   14 spark master                   | executing |               |          | 17:20:58 27/11/15 |                   |
|     14.1 configure_node             | executing | master        |          | 17:20:58 27/11/15 |                   |
|   15 spark workers                  |           |               |          |                   |                   |
|     15.1 configure_nodegroup        |           | workers       |          |                   |                   |
|       15.1.1 configure_node         |           | workers:1     |          |                   |                   |
|       15.1.2 configure_node         |           | workers:2     |          |                   |                   |
|   16 component gitarchive[mar01]    |           |               |          |                   |                   |
|     16.1 configure_node             |           | master        |          |                   |                   |
+-------------------------------------+-----------+---------------+----------+-------------------+-------------------+
50 rows in set

```
```
dtk:/service/ignite-cluster1>task-status -m stream
========================= 2015-11-27 17:15:58 +0000 start 'assembly_converge' =========================


============================================================
STAGE 1: create_nodes_stage
TIME START: 2015-11-27 17:15:57 +0000
OPERATION: CreateNodes
  master
  workers:1
  workers:2
STATUS: succeeded
DURATION: 87.0s
------------------------------------------------------------

============================================================
STAGE 2: bigtop_multiservice
TIME START: 2015-11-27 17:17:25 +0000
COMPONENT: assembly_wide/bigtop_multiservice
STATUS: succeeded
DURATION: 0.0s
------------------------------------------------------------

============================================================
STAGE 3: bigtop hiera
TIME START: 2015-11-27 17:17:35 +0000
COMPONENTS:
  node-group:workers/bigtop_multiservice::hiera
  master/bigtop_multiservice::hiera
STATUS: succeeded
DURATION: 5.3s
------------------------------------------------------------

============================================================
STAGE 4: bigtop_base
TIME START: 2015-11-27 17:17:41 +0000
COMPONENTS:
  node-group:workers/bigtop_base
  master/bigtop_base
STATUS: succeeded
DURATION: 19.8s
------------------------------------------------------------

============================================================
STAGE 5: component ignite::cluster
TIME START: 2015-11-27 17:18:01 +0000
COMPONENT: assembly_wide/ignite::cluster
STATUS: succeeded
DURATION: 0.1s
------------------------------------------------------------

============================================================
STAGE 6: ignite install and configure
TIME START: 2015-11-27 17:18:01 +0000
COMPONENTS:
  node-group:workers/ignite
  master/ignite
STATUS: succeeded
DURATION: 95.9s
------------------------------------------------------------

============================================================
STAGE 7: start ignite on seed
TIME START: 2015-11-27 17:19:38 +0000
ACTION: master/ignite.start
STATUS: succeeded
DURATION: 3.4s
RESULTS:

NODE: master
RUN: service ignite start (syscall)
RETURN CODE: 0
STDOUT:
  Starting Ignite daemon (ignite):[  OK  ]

------------------------------------------------------------

============================================================
STAGE 8: start ignite on all other nodes
TIME START: 2015-11-27 17:19:41 +0000
ACTION: node-group:workers/ignite.start
STATUS: succeeded
DURATION: 3.6s
RESULTS:

NODE: workers:1
RUN: service ignite start (syscall)
RETURN CODE: 0
STDOUT:
  Starting Ignite daemon (ignite):[  OK  ]

NODE: workers:2
RUN: service ignite start (syscall)
RETURN CODE: 0
STDOUT:
  Starting Ignite daemon (ignite):[  OK  ]

------------------------------------------------------------

============================================================
STAGE 9: namenode
TIME START: 2015-11-27 17:19:45 +0000
COMPONENT: master/hadoop::namenode
STATUS: succeeded
DURATION: 30.0s
------------------------------------------------------------

============================================================
STAGE 10: if needed leave safemode
TIME START: 2015-11-27 17:20:15 +0000
ACTION: master/hadoop::namenode.leave_safemode
STATUS: succeeded
DURATION: 2.3s
RESULTS:

NODE: master
RUN: su hdfs -c 'hdfs dfsadmin -safemode leave' (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 11: namenode smoke test
TIME START: 2015-11-27 17:20:18 +0000
ACTION: master/hadoop::namenode.smoke_test
STATUS: succeeded
DURATION: 2.1s
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
  tcp        0      0 10.90.0.220:8020            0.0.0.0:*                   LISTEN      4293/java
--
RUN: su hdfs -c "hdfs dfsadmin -safemode get" | grep OFF (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 12: datanodes
TIME START: 2015-11-27 17:20:21 +0000
COMPONENTS:
  node-group:workers/hadoop::common_hdfs
  node-group:workers/hadoop::datanode
STATUS: succeeded
DURATION: 30.1s
------------------------------------------------------------

============================================================
STAGE 13: hdfs directories for spark
TIME START: 2015-11-27 17:20:51 +0000
COMPONENT: master/hadoop::hdfs_directories
STATUS: succeeded
DURATION: 6.9s
------------------------------------------------------------
```
