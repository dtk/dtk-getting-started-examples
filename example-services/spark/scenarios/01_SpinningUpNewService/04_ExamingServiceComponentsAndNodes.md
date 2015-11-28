## Examing the nodes and components constituting a service

When the assembly "bigtop::spark" was deployed to create the service instance "spark-cluster1 the DTK server behind the scenes created in spark-cluster1 a model of the set of nodes and "components" that consititute the service. Within the DTK shell the user is able to query these nodes and components for any deployed or staged service instance. In this section we describe a few commands for querying the current state of a service and then in later scenarios show how teh user can add/delete and modfy these nodes and components and then perform actions to update the actual state of the deployed service.


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
