## Create annd deploy a service instance from an assembly
A Service module has one or more 'assemblies', each of which captures one or more services and/or applications and how the service daemons and application components map to one or more nodes. We refer to this node mapping as an application topology, which can run the gambit from a single node to a cluster with master and slave nodes to a complex high-availability configuration along with monitoring, security and other support services. In the example service module 'bigtop:spark' there is a single assembly named 'cluster', which has a master/slave topology supporting a Spark and HDFS service.

In the example below an assembly is 'deployed' meaning that its actual execution on EC2 is initiated when the user hits 'deploy'. A user can deploy the same assembly multiple times to deploy multiple copies of the assembly.  It is analogous to in EC2 launching an instance from an image, but in this case the deployed entity can have multiple nodes. This deployed entity is referred to as a 'service instance'. As an alternative to deploying an assembly in a single operation, the user can also first 'stage' the assembly to form a service instance that is not yet launched then set parameters or otherwise customize the service instance before actual launching it (see ...)


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
Navigate to the service instance context and list the set of service instances'services, which in this case wil show a single siervice instance that is in 'running' state
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
