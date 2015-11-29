## Examing the nodes and components constituting a service

When the assembly "bigtop::spark" was deployed to create the service instance "spark-cluster1" the DTK server behind the scenes created in spark-cluster1 a model of the set of nodes and "components" that consititute the service. Within the DTK shell the user is able to query these nodes and components for any deployed or staged service instance. In this section we describe a few commands for querying the current state of a service and then in later scenarios show how the user can add/delete and modfy these nodes and components and then perform actions to update the actual state of the deployed service.

Each service instance is composed of one or more nodes. For EC2 deployments a node corresponds to an EC2 instance. The assembly defining a service can refer to either a "node" or "node-group". A node-group corresponding to a set of nodes with the same components whose size is controlled by setting a "cardinality parameter". We illustrate in a later section how to scale up and down a cluster by adjusting the cardinality of a node group and then executing an action to actuate the change. The DTK enables the user to define an assembly with multiple node groups so it can represent a deployment where for example there is a Spark cluster and Cassandra cluster, each one can be scaled seperately. In the example bigtop:spark assembly there is just a single node group that contains the slave/worker daemons for Spark and HDFS. By navigating to a desired service instance and then using the 'list-nodes' command the user can see the existing nodes and node groups. In this example the user can type:
```
cd /service/spark-cluster1
list-nodes

```
and will see something like:
```
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME                                  |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| 2147493838 | master   | i-5cfe95ec  | t2.medium | amazon-linux | running   | ec2-54-88-11-179.compute-1.amazonaws.com  |
| 2147493998 | slaves:1 | i-e8fd9658  | t2.medium | amazon-linux | running   | ec2-54-88-67-35.compute-1.amazonaws.com   |
| 2147493999 | slaves:2 | i-5efe95ee  | t2.medium | amazon-linux | running   | ec2-54-86-215-188.compute-1.amazonaws.com |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
3 rows in set
```
This shows the nodes and the members for each node group. In this example there is a node-group named 'slaves' that has two members that are denoted by 'slaves:1' and 'slaves:2'

Components represent things like namenode, spark master, datanode etc daemons as well as anything that can be installed or configured. A component can live on a node or live on a node group to have a set nodes configured with the same daemon or software. Components can alo be "at the service level" and not placed on a specific node or node-group. These are used to set cluster-wide of system-wide parameters. To see the components for spark-cluster1, the user can issue the commands:
```
cd /service/spark-cluster1
list-components
```
and see something like
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
TODO: give a brief explanation of components above

Other key parts of a service state are a set of attributes that can be attached to the node, node-groups, and components as well as "component links" that capture component dependencies. The display and use of these features will be covered under later sections.
