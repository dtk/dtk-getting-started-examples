```
dtk:/service/spark-cluster1>list-attributes
+------------+-------------------------------------------------+---------------------------------------------------+---------+
| ID         | PATH                                            | VALUE                                             | TYPE    |
+------------+-------------------------------------------------+---------------------------------------------------+---------+
| 2147495315 | bigtop_multiservice/aggregate_input             | {hadoop_version=>2.7, spark_version=>1.5.1}       | hash    |
| 2147495316 | bigtop_multiservice/aggregate_output            | {java_version=>1.7, hadoop_version=>2.7, spar ... | hash    |
| 2147495314 | bigtop_multiservice/java_version                | 1.7                                               | string  |
| 2147495308 | hadoop::cluster/version                         | 2.7                                               | string  |
| 2147495319 | master/bigtop_base/with_jdk                     |                                                   | boolean |
| 2147495321 | master/bigtop_base/with_maven                   |                                                   | boolean |
| 2147495317 | master/bigtop_multiservice::hiera/globals       | {java_version=>1.7, hadoop_version=>2.7, spar ... | hash    |
| 2147495541 | master/gitarchive[mar01]/day                    | 01                                                | string  |
| 2147495542 | master/gitarchive[mar01]/hours                  |                                                   | string  |
| 2147495544 | master/gitarchive[mar01]/load_command_line      | /usr/share/dtk/load_http_into_hdfs mar01 ec2- ... | string  |
| 2147495540 | master/gitarchive[mar01]/month                  | 03                                                | string  |
| 2147495543 | master/gitarchive[mar01]/owner                  | ec2-user                                          | string  |
| 2147495539 | master/gitarchive[mar01]/year                   | 2015                                              | string  |
| 2147495313 | master/hadoop::hdfs_directories/daemon_dirs     | [[{path=>/user/local/spark/, mode=>1777, owne ... | array   |
| 2147495311 | master/hadoop::namenode/hdfs_daemon_user        | hdfs                                              | string  |
| 2147495310 | master/hadoop::namenode/http_port               | 50070                                             | port    |
| 2147495309 | master/hadoop::namenode/port                    | 8020                                              | port    |
| 2147495296 | master/spark::master/cassandra_host             |                                                   | string  |
| 2147495297 | master/spark::master/eventlog_dir               | /user/local/spark                                 | string  |
| 2147495295 | master/spark::master/eventlog_enabled           | true                                              | boolean |
| 2147495299 | master/spark::master/hdfs_namenode_host         | ec2-54-174-107-248.compute-1.amazonaws.com        | string  |
| 2147495300 | master/spark::master/hdfs_working_dirs          | [{path=>/user/local/spark/, mode=>1777, owner ... | json    |
| 2147495298 | master/spark::master/history_server_enabled     | true                                              | boolean |
| 2147495290 | master/spark::master/master_host                | 10.90.0.22                                        | string  |
| 2147495292 | master/spark::master/master_port                | 7077                                              | port    |
| 2147495293 | master/spark::master/master_ui_port             | 8080                                              | port    |
| 2147495291 | master/spark::master/spark_version              | 1.5.1                                             | string  |
| 2147495320 | slaves/bigtop_base/with_jdk                     |                                                   | boolean |
| 2147495322 | slaves/bigtop_base/with_maven                   |                                                   | boolean |
| 2147495318 | slaves/bigtop_multiservice::hiera/globals       | {java_version=>1.7, hadoop_version=>2.7, spar ... | hash    |
| 2147495258 | slaves/cardinality                              | 2                                                 | integer |
| 2147495312 | slaves/hadoop::common_hdfs/hadoop_namenode_host | [ec2-54-174-107-248.compute-1.amazonaws.com]      | array   |
| 2147495307 | slaves/spark::common/cassandra_host             |                                                   | string  |
| 2147495302 | slaves/spark::common/master_host                | 10.90.0.22                                        | string  |
| 2147495303 | slaves/spark::common/master_port                | 7077                                              | port    |
| 2147495301 | slaves/spark::common/worker_port                | 8081                                              | port    |
| 2147495289 | spark::cluster/version                          | 1.5.1                                             | string  |
+------------+-------------------------------------------------+---------------------------------------------------+---------+
37 rows in set
```

```
dtk:/service/spark-cluster1>list-attributes -f yaml
---
components:
  bigtop_multiservice/:
    attributes:
      aggregate_input:
        hadoop_version: '2.7'
        spark_version: 1.5.1
      aggregate_output:
        java_version: '1.7'
        hadoop_version: '2.7'
        spark_version: 1.5.1
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
      bigtop_multiservice::hiera/:
        attributes:
          globals:
            java_version: '1.7'
            hadoop_version: '2.7'
            spark_version: 1.5.1
      gitarchive[mar01]/:
        attributes:
          day: '01'
          hours:
          load_command_line: /usr/share/dtk/load_http_into_hdfs mar01 ec2-user 'http://data.githubarchive.org'
            /user/local/ec2-user/data/gitarchive/mar01
          month: '03'
          owner: ec2-user
          year: '2015'
      hadoop::hdfs_directories/:
        attributes:
          daemon_dirs:
          - - path: /user/local/spark/
              mode: '1777'
              owner: spark
            - path: /var/log/spark/apps
              mode: '1777'
              owner: spark
              group: spark
      hadoop::namenode/:
        attributes:
          hdfs_daemon_user: hdfs
          http_port: 50070
          port: 8020
      spark::master/:
        attributes:
          cassandra_host:
          eventlog_dir: /user/local/spark
          eventlog_enabled: true
          hdfs_namenode_host: ec2-54-174-107-248.compute-1.amazonaws.com
          hdfs_working_dirs:
          - path: /user/local/spark/
            mode: '1777'
            owner: spark
          - path: /var/log/spark/apps
            mode: '1777'
            owner: spark
            group: spark
          history_server_enabled: true
          master_host: 10.90.0.22
          master_port: 7077
          master_ui_port: 8080
          spark_version: 1.5.1
  slaves/:
    attributes:
      cardinality: 2
    components:
      bigtop_base/:
        attributes:
          with_jdk:
          with_maven:
      bigtop_multiservice::hiera/:
        attributes:
          globals:
            java_version: '1.7'
            hadoop_version: '2.7'
            spark_version: 1.5.1
      hadoop::common_hdfs/:
        attributes:
          hadoop_namenode_host:
          - ec2-54-174-107-248.compute-1.amazonaws.com
      spark::common/:
        attributes:
          cassandra_host:
          master_host: 10.90.0.22
          master_port: 7077
          worker_port: 8081

```
```
dtk:/service/spark-cluster1>list-components
+------------+-----------------------------------+
| ID         | NAME                              |
+------------+-----------------------------------+
| 2147495284 | bigtop_multiservice               |
| 2147495279 | hadoop::cluster                   |
| 2147495288 | master/bigtop_base                |
| 2147495286 | master/bigtop_multiservice::hiera |
| 2147495537 | master/gitarchive[mar01]          |
| 2147495283 | master/hadoop::hdfs_directories   |
| 2147495280 | master/hadoop::namenode           |
| 2147495276 | master/spark::master              |
| 2147495287 | slaves/bigtop_base                |
| 2147495285 | slaves/bigtop_multiservice::hiera |
| 2147495281 | slaves/hadoop::common_hdfs        |
| 2147495282 | slaves/hadoop::datanode           |
| 2147495278 | slaves/spark::common              |
| 2147495277 | slaves/spark::worker              |
| 2147495275 | spark::cluster                    |
+------------+-----------------------------------+
15 rows in set
```

```
dtk:/service/spark-cluster1>list-components --deps
+------------+-----------------------------------+--------------------------+---------------------------------+
| ID         | NAME                              | DEPENDS ON               | SATISFIED BY                    |
+------------+-----------------------------------+--------------------------+---------------------------------+
| 2147495284 | bigtop_multiservice               |                          |                                 |
| 2147495279 | hadoop::cluster                   | bigtop_multiservice      | bigtop_multiservice             |
| 2147495288 | master/bigtop_base                |                          |                                 |
| 2147495286 | master/bigtop_multiservice::hiera | bigtop_multiservice      | bigtop_multiservice             |
| 2147495537 | master/gitarchive[mar01]          |                          |                                 |
| 2147495283 | master/hadoop::hdfs_directories   | hadoop::namenode         | master/hadoop::namenode         |
| 2147495280 | master/hadoop::namenode           | bigtop_base              | master/bigtop_base              |
| 2147495276 | master/spark::master              | hadoop::hdfs_directories | master/hadoop::hdfs_directories |
|            |                                   | cassandra::cluster       |                                 |
| 2147495287 | slaves/bigtop_base                |                          |                                 |
| 2147495285 | slaves/bigtop_multiservice::hiera | bigtop_multiservice      | bigtop_multiservice             |
| 2147495281 | slaves/hadoop::common_hdfs        | bigtop_base              | slaves/bigtop_base              |
|            |                                   | hadoop::namenode         | master/hadoop::namenode         |
| 2147495282 | slaves/hadoop::datanode           | hadoop::common_hdfs      | slaves/hadoop::common_hdfs      |
| 2147495278 | slaves/spark::common              | bigtop_base              | slaves/bigtop_base              |
|            |                                   | spark::master            | master/spark::master            |
|            |                                   | cassandra::cluster       |                                 |
| 2147495277 | slaves/spark::worker              | spark::common            | slaves/spark::common            |
| 2147495275 | spark::cluster                    | bigtop_multiservice      | bigtop_multiservice             |
+------------+-----------------------------------+--------------------------+---------------------------------+
19 rows in set

```


```
