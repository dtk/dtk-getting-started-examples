```
dtk:/>cd service-module/bigtop:spark/
service-module/bigtop:spark/assembly  service-module/bigtop:spark/remotes
dtk:/>cd service-module/bigtop:spark/assembly/cluster
dtk:/service-module/bigtop:spark/assembly/cluster>stage spark-cluster2
---
new_service_instance:
  name: spark-cluster2
  id: 2147496392

dtk:/service-module/bigtop:spark/assembly/cluster>cd /service
dtk:/service>ls
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147495246 | spark-cluster1 | running | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 16:40:59 27/11/15 |
| 2147496392 | spark-cluster2 | pending |           | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 18:18:42 27/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
2 rows in set

dtk:/service>cd  spark-cluster2
```
dtk614-rich@dtkhost6:~/dtk$ export EDITOR emacs

```
dtk:/service/spark-cluster2>edit-attributes
---
components:
  bigtop_multiservice/:
    attributes:
      java_version: '1.7'
  hadoop::cluster/:
    attributes:
      version: '2.7'
  spark::cluster/:
    attributes:
      version: 1.5.1
nodes:
  master/:
    components:
      bigtop_base/:
        attributes:
          with_jdk:
          with_maven:
      spark::master/:
        attributes:
          cassandra_host:
          eventlog_dir: /user/local/spark
          eventlog_enabled: true
          hdfs_working_dirs:
          - path: /user/local/spark/
            mode: '1777'
            owner: spark
          - path: /var/log/spark/apps
            mode: '1777'
            owner: spark
            group: spark
          history_server_enabled: true
          master_port: 7077
          master_ui_port: 8080
```
```
dtk:/service/spark-cluster2>converge -s
========================= start 'assembly_converge' =========================


============================================================
STAGE 1: create_nodes_stage
TIME START: 2015-11-27 18:22:48 +0000
OPERATION: CreateNodes
  master
  slaves:1
  slaves:2
STATUS: succeeded
DURATION: 85.9s
------------------------------------------------------------

============================================================
STAGE 2: bigtop_multiservice
TIME START: 2015-11-27 18:24:14 +0000
COMPONENT: assembly_wide/bigtop_multiservice
STATUS: succeeded
DURATION: 0.0s
------------------------------------------------------------

============================================================
STAGE 3: bigtop hiera
COMPONENTS:
  node-group:slaves/bigtop_multiservice::hiera
  master/bigtop_multiservice::hiera
STATUS: succeeded
DURATION: 6.6s
------------------------------------------------------------

```

