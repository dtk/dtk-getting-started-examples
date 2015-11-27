
```
dtk:/service/spark-cluster1>set-attribute slaves/cardinality 4
Status: OK
dtk:/service/spark-cluster1>task-status -m stream
========================= 2015-11-27 17:59:52 +0000 start 'assembly_converge' =========================


============================================================
STAGE 1: create_nodes_stage
TIME START: 2015-11-27 17:59:52 +0000
OPERATION: CreateNodes
  slaves:3
  slaves:4
STATUS: succeeded
DURATION: 92.4s
------------------------------------------------------------

============================================================
STAGE 2: bigtop_multiservice
TIME START: 2015-11-27 18:01:24 +0000
COMPONENT: assembly_wide/bigtop_multiservice
STATUS: succeeded
DURATION: 0.0s
------------------------------------------------------------

============================================================
STAGE 3: bigtop hiera
TIME START: 2015-11-27 18:01:25 +0000
COMPONENTS:
  node-group:slaves/bigtop_multiservice::hiera
  master/bigtop_multiservice::hiera
STATUS: succeeded
DURATION: 13.8s
------------------------------------------------------------

============================================================
STAGE 4: bigtop_base
TIME START: 2015-11-27 18:01:39 +0000
COMPONENTS:
  node-group:slaves/bigtop_base
  master/bigtop_base
STATUS: succeeded
DURATION: 7.3s
------------------------------------------------------------

============================================================
STAGE 5: namenode
TIME START: 2015-11-27 18:01:47 +0000
COMPONENT: master/hadoop::namenode
STATUS: succeeded
DURATION: 3.2s
------------------------------------------------------------

============================================================
STAGE 6: if needed leave safemode
TIME START: 2015-11-27 18:01:50 +0000
ACTION: master/hadoop::namenode.leave_safemode
STATUS: succeeded
DURATION: 2.0s
RESULTS:

NODE: master
RUN: su hdfs -c 'hdfs dfsadmin -safemode leave' (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 7: namenode smoke test
TIME START: 2015-11-27 18:01:52 +0000
ACTION: master/hadoop::namenode.smoke_test
STATUS: succeeded
DURATION: 2.0s
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
  tcp        0      0 10.90.0.22:8020             0.0.0.0:*                   LISTEN      3617/java
--
RUN: su hdfs -c "hdfs dfsadmin -safemode get" | grep OFF (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 8: datanodes
TIME START: 2015-11-27 18:01:55 +0000
COMPONENTS:
  node-group:slaves/hadoop::common_hdfs
  node-group:slaves/hadoop::datanode
STATUS: succeeded
DURATION: 36.5s
------------------------------------------------------------

============================================================
STAGE 9: hdfs directories for spark
TIME START: 2015-11-27 18:02:32 +0000
COMPONENT: master/hadoop::hdfs_directories
STATUS: succeeded
DURATION: 5.2s
------------------------------------------------------------

============================================================
STAGE 10: spark master
TIME START: 2015-11-27 18:02:37 +0000
COMPONENT: master/spark::master
STATUS: succeeded
DURATION: 12.2s
------------------------------------------------------------

============================================================
STAGE 11: spark workers
TIME START: 2015-11-27 18:02:50 +0000
COMPONENTS:
  node-group:slaves/spark::common
  node-group:slaves/spark::worker
STATUS: succeeded
DURATION: 65.9s
------------------------------------------------------------

============================================================
STAGE 12: component gitarchive[mar01]
TIME START: 2015-11-27 18:03:56 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 2.8s
------------------------------------------------------------

========================= end: 'assembly_converge' (total duration: 246.9s) =========================
```
```
========================= end: 'assembly_converge' (total duration: 246.9s) =========================
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | succeeded |               | 246.9s   | 17:59:52 27/11/15 | 18:03:59 27/11/15 |
|   1 create_nodes_stage           | succeeded |               | 92.4s    | 17:59:52 27/11/15 | 18:01:24 27/11/15 |
|     1.1 create_node              | succeeded | slaves:3      | 92.4s    | 17:59:52 27/11/15 | 18:01:24 27/11/15 |
|     1.2 create_node              | succeeded | slaves:4      | 80.8s    | 17:59:52 27/11/15 | 18:01:13 27/11/15 |
|   2 bigtop_multiservice          | succeeded |               | 0.0s     | 18:01:24 27/11/15 | 18:01:24 27/11/15 |
|     2.1 configure_node           | succeeded | assembly_wide | 0.0s     | 18:01:24 27/11/15 | 18:01:24 27/11/15 |
|   3 bigtop hiera                 | succeeded |               | 13.8s    | 18:01:25 27/11/15 | 18:01:39 27/11/15 |
|     3.1 configure_nodegroup      | succeeded | slaves        | 13.8s    | 18:01:25 27/11/15 | 18:01:39 27/11/15 |
|       3.1.1 configure_node       | succeeded | slaves:3      | 3.8s     | 18:01:35 27/11/15 | 18:01:39 27/11/15 |
|       3.1.2 configure_node       | succeeded | slaves:4      | 3.3s     | 18:01:35 27/11/15 | 18:01:39 27/11/15 |
|       3.1.3 configure_node       | succeeded | slaves:1      | 1.0s     | 18:01:25 27/11/15 | 18:01:26 27/11/15 |
|       3.1.4 configure_node       | succeeded | slaves:2      | 1.0s     | 18:01:25 27/11/15 | 18:01:26 27/11/15 |
|     3.2 configure_node           | succeeded | master        | 1.0s     | 18:01:25 27/11/15 | 18:01:26 27/11/15 |
|   4 bigtop_base                  | succeeded |               | 7.3s     | 18:01:39 27/11/15 | 18:01:46 27/11/15 |
|     4.1 configure_nodegroup      | succeeded | slaves        | 7.3s     | 18:01:39 27/11/15 | 18:01:46 27/11/15 |
|       4.1.1 configure_node       | succeeded | slaves:3      | 6.2s     | 18:01:39 27/11/15 | 18:01:45 27/11/15 |
|       4.1.2 configure_node       | succeeded | slaves:4      | 6.6s     | 18:01:40 27/11/15 | 18:01:46 27/11/15 |
|       4.1.3 configure_node       | succeeded | slaves:1      | 3.9s     | 18:01:40 27/11/15 | 18:01:44 27/11/15 |
|       4.1.4 configure_node       | succeeded | slaves:2      | 3.9s     | 18:01:39 27/11/15 | 18:01:43 27/11/15 |
|     4.2 configure_node           | succeeded | master        | 3.9s     | 18:01:39 27/11/15 | 18:01:43 27/11/15 |
|   5 namenode                     | succeeded |               | 3.2s     | 18:01:47 27/11/15 | 18:01:50 27/11/15 |
|     5.1 configure_node           | succeeded | master        | 3.2s     | 18:01:47 27/11/15 | 18:01:50 27/11/15 |
|   6 if needed leave safemode     | succeeded |               | 2.0s     | 18:01:50 27/11/15 | 18:01:52 27/11/15 |
|     6.1 action                   | succeeded | master        | 2.0s     | 18:01:50 27/11/15 | 18:01:52 27/11/15 |
|   7 namenode smoke test          | succeeded |               | 2.0s     | 18:01:52 27/11/15 | 18:01:54 27/11/15 |
|     7.1 action                   | succeeded | master        | 2.0s     | 18:01:52 27/11/15 | 18:01:54 27/11/15 |
|   8 datanodes                    | succeeded |               | 36.5s    | 18:01:55 27/11/15 | 18:02:31 27/11/15 |
|     8.1 configure_nodegroup      | succeeded | slaves        | 36.5s    | 18:01:55 27/11/15 | 18:02:31 27/11/15 |
|       8.1.1 configure_node       | succeeded | slaves:3      | 34.4s    | 18:01:55 27/11/15 | 18:02:29 27/11/15 |
|       8.1.2 configure_node       | succeeded | slaves:4      | 35.8s    | 18:01:55 27/11/15 | 18:02:31 27/11/15 |
|       8.1.3 configure_node       | succeeded | slaves:1      | 3.2s     | 18:01:55 27/11/15 | 18:01:58 27/11/15 |
|       8.1.4 configure_node       | succeeded | slaves:2      | 3.4s     | 18:01:55 27/11/15 | 18:01:58 27/11/15 |
|   9 hdfs directories for spark   | succeeded |               | 5.2s     | 18:02:32 27/11/15 | 18:02:37 27/11/15 |
|     9.1 configure_node           | succeeded | master        | 5.2s     | 18:02:32 27/11/15 | 18:02:37 27/11/15 |
|   10 spark master                | succeeded |               | 12.2s    | 18:02:37 27/11/15 | 18:02:49 27/11/15 |
|     10.1 configure_node          | succeeded | master        | 12.2s    | 18:02:37 27/11/15 | 18:02:49 27/11/15 |
|   11 spark workers               | succeeded |               | 65.9s    | 18:02:50 27/11/15 | 18:03:56 27/11/15 |
|     11.1 configure_nodegroup     | succeeded | slaves        | 65.9s    | 18:02:50 27/11/15 | 18:03:56 27/11/15 |
|       11.1.1 configure_node      | succeeded | slaves:3      | 65.5s    | 18:02:50 27/11/15 | 18:03:56 27/11/15 |
|       11.1.2 configure_node      | succeeded | slaves:4      | 65.1s    | 18:02:50 27/11/15 | 18:03:55 27/11/15 |
|       11.1.3 configure_node      | succeeded | slaves:1      | 3.6s     | 18:02:50 27/11/15 | 18:02:54 27/11/15 |
|       11.1.4 configure_node      | succeeded | slaves:2      | 3.8s     | 18:02:50 27/11/15 | 18:02:54 27/11/15 |
|   12 component gitarchive[mar01] | succeeded |               | 2.8s     | 18:03:56 27/11/15 | 18:03:59 27/11/15 |
|     12.1 configure_node          | succeeded | master        | 2.8s     | 18:03:56 27/11/15 | 18:03:59 27/11/15 |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
44 rows in set
```
```
dtk:/service/spark-cluster1>list-nodes
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME                                   |
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
| 2147495247 | master   | i-e3255353  | t2.medium | amazon-linux | running   | ec2-54-174-107-248.compute-1.amazonaws.com |
| 2147495396 | slaves:1 | i-e2255352  | t2.medium | amazon-linux | running   | ec2-54-165-144-202.compute-1.amazonaws.com |
| 2147495397 | slaves:2 | i-e4255354  | t2.medium | amazon-linux | running   | ec2-54-152-135-47.compute-1.amazonaws.com  |
| 2147496112 | slaves:3 | i-0d7402bd  | t2.medium | amazon-linux | running   | ec2-54-164-20-237.compute-1.amazonaws.com  |
| 2147496113 | slaves:4 | i-fa72044a  | t2.medium | amazon-linux | running   | ec2-54-172-156-125.compute-1.amazonaws.com |
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
```
```
dtk:/service/spark-cluster1>set-attribute slaves/cardinality 2
Status: OK
dtk:/service/spark-cluster1>converge
Status: OK
dtk:/service/spark-cluster1>list-nodes
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME                                   |
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
| 2147495247 | master   | i-e3255353  | t2.medium | amazon-linux | running   | ec2-54-174-107-248.compute-1.amazonaws.com |
| 2147495396 | slaves:1 | i-e2255352  | t2.medium | amazon-linux | running   | ec2-54-165-144-202.compute-1.amazonaws.com |
| 2147495397 | slaves:2 | i-e4255354  | t2.medium | amazon-linux | running   | ec2-54-152-135-47.compute-1.amazonaws.com  |
+------------+----------+-------------+-----------+--------------+-----------+--------------------------------------------+
3 rows in set

```


