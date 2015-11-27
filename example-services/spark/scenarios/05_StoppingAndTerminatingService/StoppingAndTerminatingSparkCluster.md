```
dtk:/service/spark-cluster1>list-nodes
+------------+----------+-------------+-----------+--------------+-----------+----------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME |
+------------+----------+-------------+-----------+--------------+-----------+----------+
| 2147495247 | master   | i-e3255353  | t2.medium | amazon-linux | stopped   |          |
| 2147495396 | slaves:1 | i-e2255352  | t2.medium | amazon-linux | stopped   |          |
| 2147495397 | slaves:2 | i-e4255354  | t2.medium | amazon-linux | stopped   |          |
+------------+----------+-------------+-----------+--------------+-----------+----------+
3 rows in set
```
```
tk:/service/spark-cluster1>
dtk:/service/spark-cluster1>cd ../
dtk:/service>ls
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147495246 | spark-cluster1 | stopped | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 16:40:59 27/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
1 row in set
```
```
dtk:/service/spark-cluster1>converge -s
Workspace service is stopped, do you want to start it? (yes|no): yes
```
```
dtk:/service/spark-cluster1>converge -s
Workspace service is stopped, do you want to start it? (yes|no): yes
========================= 2015-11-27 18:10:35 +0000 start 'assembly_converge' =========================


============================================================
STAGE 1: power_on_nodes_stage
TIME START: 2015-11-27 18:10:35 +0000
OPERATION: PowerOnNodes
  master
  slaves:1
  slaves:2
STATUS: succeeded
DURATION: 66.5s
------------------------------------------------------------

============================================================
STAGE 2: bigtop_multiservice
TIME START: 2015-11-27 18:11:42 +0000
COMPONENT: assembly_wide/bigtop_multiservice
STATUS: succeeded
DURATION: 0.0s
------------------------------------------------------------

============================================================
STAGE 3: bigtop hiera
TIME START: 2015-11-27 18:11:42 +0000
COMPONENTS:
  node-group:slaves/bigtop_multiservice::hiera
  master/bigtop_multiservice::hiera
STATUS: succeeded
DURATION: 4.1s
------------------------------------------------------------

============================================================
STAGE 4: bigtop_base
TIME START: 2015-11-27 18:11:47 +0000
COMPONENTS:
  node-group:slaves/bigtop_base
  master/bigtop_base
STATUS: succeeded
DURATION: 6.8s
------------------------------------------------------------

============================================================
STAGE 5: namenode
TIME START: 2015-11-27 18:11:54 +0000
COMPONENT: master/hadoop::namenode
STATUS: succeeded
DURATION: 4.2s
------------------------------------------------------------

============================================================
STAGE 6: if needed leave safemode
TIME START: 2015-11-27 18:11:58 +0000
ACTION: master/hadoop::namenode.leave_safemode
STATUS: succeeded
DURATION: 2.6s
RESULTS:

NODE: master
RUN: su hdfs -c 'hdfs dfsadmin -safemode leave' (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 7: namenode smoke test
TIME START: 2015-11-27 18:12:01 +0000
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
  tcp        0      0 10.90.0.22:8020             0.0.0.0:*                   LISTEN      2530/java
--
RUN: su hdfs -c "hdfs dfsadmin -safemode get" | grep OFF (syscall)
RETURN CODE: 0
STDOUT:
  Safe mode is OFF

------------------------------------------------------------

============================================================
STAGE 8: datanodes
TIME START: 2015-11-27 18:12:04 +0000
COMPONENTS:
  node-group:slaves/hadoop::common_hdfs
  node-group:slaves/hadoop::datanode
STATUS: succeeded
DURATION: 18.7s
------------------------------------------------------------

============================================================
STAGE 9: hdfs directories for spark
TIME START: 2015-11-27 18:12:23 +0000
COMPONENT: master/hadoop::hdfs_directories
STATUS: succeeded
DURATION: 6.6s
------------------------------------------------------------

============================================================
STAGE 10: spark master
TIME START: 2015-11-27 18:12:30 +0000
COMPONENT: master/spark::master
STATUS: succeeded
DURATION: 12.4s
------------------------------------------------------------

============================================================
STAGE 11: spark workers
TIME START: 2015-11-27 18:12:43 +0000
COMPONENTS:
  node-group:slaves/spark::common
  node-group:slaves/spark::worker
STATUS: succeeded
DURATION: 8.1s
------------------------------------------------------------

============================================================
STAGE 12: component gitarchive[mar01]
TIME START: 2015-11-27 18:12:51 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 3.0s
------------------------------------------------------------

========================= end: 'assembly_converge' (total duration: 138.6s) =========================
Status: OK
dtk:/service/spark-cluster1>

```
```
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | succeeded |               | 138.6s   | 18:10:35 27/11/15 | 18:12:54 27/11/15 |
|   1 power_on_nodes_stage         | succeeded |               | 66.5s    | 18:10:35 27/11/15 | 18:11:42 27/11/15 |
|     1.1 power_on_node            | succeeded | master        | 54.4s    | 18:10:35 27/11/15 | 18:11:30 27/11/15 |
|     1.2 power_on_node            | succeeded | slaves:1      | 60.3s    | 18:10:35 27/11/15 | 18:11:36 27/11/15 |
|     1.3 power_on_node            | succeeded | slaves:2      | 66.5s    | 18:10:35 27/11/15 | 18:11:42 27/11/15 |
|   2 bigtop_multiservice          | succeeded |               | 0.0s     | 18:11:42 27/11/15 | 18:11:42 27/11/15 |
|     2.1 configure_node           | succeeded | assembly_wide | 0.0s     | 18:11:42 27/11/15 | 18:11:42 27/11/15 |
|   3 bigtop hiera                 | succeeded |               | 4.1s     | 18:11:42 27/11/15 | 18:11:46 27/11/15 |
|     3.1 configure_nodegroup      | succeeded | slaves        | 3.0s     | 18:11:42 27/11/15 | 18:11:45 27/11/15 |
|       3.1.1 configure_node       | succeeded | slaves:1      | 2.5s     | 18:11:42 27/11/15 | 18:11:45 27/11/15 |
|       3.1.2 configure_node       | succeeded | slaves:2      | 2.8s     | 18:11:42 27/11/15 | 18:11:45 27/11/15 |
|     3.2 configure_node           | succeeded | master        | 3.7s     | 18:11:43 27/11/15 | 18:11:46 27/11/15 |
|   4 bigtop_base                  | succeeded |               | 6.8s     | 18:11:47 27/11/15 | 18:11:53 27/11/15 |
|     4.1 configure_nodegroup      | succeeded | slaves        | 6.5s     | 18:11:47 27/11/15 | 18:11:53 27/11/15 |
|       4.1.1 configure_node       | succeeded | slaves:1      | 6.2s     | 18:11:47 27/11/15 | 18:11:53 27/11/15 |
|       4.1.2 configure_node       | succeeded | slaves:2      | 6.4s     | 18:11:47 27/11/15 | 18:11:53 27/11/15 |
|     4.2 configure_node           | succeeded | master        | 5.5s     | 18:11:47 27/11/15 | 18:11:52 27/11/15 |
|   5 namenode                     | succeeded |               | 4.2s     | 18:11:54 27/11/15 | 18:11:58 27/11/15 |
|     5.1 configure_node           | succeeded | master        | 4.2s     | 18:11:54 27/11/15 | 18:11:58 27/11/15 |
|   6 if needed leave safemode     | succeeded |               | 2.6s     | 18:11:58 27/11/15 | 18:12:01 27/11/15 |
|     6.1 action                   | succeeded | master        | 2.6s     | 18:11:58 27/11/15 | 18:12:01 27/11/15 |
|   7 namenode smoke test          | succeeded |               | 2.2s     | 18:12:01 27/11/15 | 18:12:03 27/11/15 |
|     7.1 action                   | succeeded | master        | 2.2s     | 18:12:01 27/11/15 | 18:12:03 27/11/15 |
|   8 datanodes                    | succeeded |               | 18.7s    | 18:12:04 27/11/15 | 18:12:22 27/11/15 |
|     8.1 configure_nodegroup      | succeeded | slaves        | 18.7s    | 18:12:04 27/11/15 | 18:12:22 27/11/15 |
|       8.1.1 configure_node       | succeeded | slaves:1      | 18.6s    | 18:12:04 27/11/15 | 18:12:22 27/11/15 |
|       8.1.2 configure_node       | succeeded | slaves:2      | 18.6s    | 18:12:04 27/11/15 | 18:12:22 27/11/15 |
|   9 hdfs directories for spark   | succeeded |               | 6.6s     | 18:12:23 27/11/15 | 18:12:29 27/11/15 |
|     9.1 configure_node           | succeeded | master        | 6.6s     | 18:12:23 27/11/15 | 18:12:29 27/11/15 |
|   10 spark master                | succeeded |               | 12.4s    | 18:12:30 27/11/15 | 18:12:42 27/11/15 |
|     10.1 configure_node          | succeeded | master        | 12.4s    | 18:12:30 27/11/15 | 18:12:42 27/11/15 |
|   11 spark workers               | succeeded |               | 8.1s     | 18:12:43 27/11/15 | 18:12:51 27/11/15 |
|     11.1 configure_nodegroup     | succeeded | slaves        | 8.1s     | 18:12:43 27/11/15 | 18:12:51 27/11/15 |
|       11.1.1 configure_node      | succeeded | slaves:1      | 7.9s     | 18:12:43 27/11/15 | 18:12:50 27/11/15 |
|       11.1.2 configure_node      | succeeded | slaves:2      | 7.9s     | 18:12:43 27/11/15 | 18:12:51 27/11/15 |
|   12 component gitarchive[mar01] | succeeded |               | 3.0s     | 18:12:51 27/11/15 | 18:12:54 27/11/15 |
|     12.1 configure_node          | succeeded | master        | 3.0s     | 18:12:51 27/11/15 | 18:12:54 27/11/15 |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
37 rows in set
```
```
dtk:/service/spark-cluster1>list-nodes
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME                                  |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| 2147495247 | master   | i-e3255353  | t2.medium | amazon-linux | running   | ec2-52-23-217-180.compute-1.amazonaws.com |
| 2147495396 | slaves:1 | i-e2255352  | t2.medium | amazon-linux | running   | ec2-54-165-138-89.compute-1.amazonaws.com |
| 2147495397 | slaves:2 | i-e4255354  | t2.medium | amazon-linux | running   | ec2-54-173-134-64.compute-1.amazonaws.com |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
3 rows in set

```

