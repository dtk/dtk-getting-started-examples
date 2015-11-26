## Install the Spark service module
In order to deploy services, service modules must first be intsalled from the DTK Catalog manager. Below shows intsllation of a Service Module for deployiong spark clusters

cut-and-paste
```
cd service-module
install bigtop:spark
```
with outputs
```
dtk:/>cd service-module
dtk:/service-module>install bigtop:spark
Auto-installing missing module(s)
Installing component module 'maestrodev:wget' ... Done.
Installing component module 'dtk:dtk_util' ... Done.
Installing component module 'puppetlabs:stdlib' ... Done.
Installing component module 'bigtop:kerberos' ... Done.
Installing component module 'bigtop:bigtop_toolchain' ... Done.
Installing component module 'bigtop:dataset' ... Done.
Installing component module 'maestrodev:maven' ... Done.
Installing component module 'dtk:host' ... Done.
Installing component module 'bigtop-new:spark' ... Done.
Installing component module 'bigtop-new:hadoop' ... Done.
Installing component module 'datasets:gitarchive' ... Done.
Installing component module 'bigtop:bigtop_multiservice' ... Done.
Installing component module 'bigtop-new:bigtop_base' ... Done.
Resuming DTK Network import for service_module 'bigtop:spark' ... Done
module_directory: /home/dtk614-rich/dtk/service_modules/bigtop/spark
```
## List and deploy 'Assemblies' 
A Service module has one or more 'assemblies', which cab represent different application toolpgies such as a cluster, asingle node, a High-Availability configuration, etc. The example below shows a service module with assembly that is a cluster running both Spark and HDFS. A single assembly can be deployed one or multiple times to for example create clusters for each developer or for different ops environments. In the example below an assembly is 'deployed' meaning that its actual execution on EC2 is iniiated. Each time an assembly is deployed a new service instance is created. As an altrnative to dircetly deploying an assembly, the user can also first 'stage' the assembly to form a service insnace taht is not yet launched then set paramters or otehrwise customzie the service isnatnce before actual launching it (see ...)

Cut-and-paste to 
- List service modules
- Navigate to 'bigtop:spark'service module and list its assemblies
- Deploy assembly with name 'cluster' and name teh service instance spark-cluster1
- Navigate to 'service context to if new service is running'
```
cd /service-module
ls
cd bigtop:spark
list-assemblies
cd assembly/cluster
deploy spark-cluster1
cd /service
ls
```

### List service modules
```
dtk:/service-module>list
+------------+--------------+---------------------+------------+
| ID         | NAME         | REMOTE(S)           | DSL PARSED |
+------------+--------------+---------------------+------------+
| 2147491114 | bigtop:spark | dtkn://bigtop/spark | true       |
+------------+--------------+---------------------+------------+
1 row in set

```
### Navigate to 'bigtop:spark' service module and list its assemblies
```
dtk:/service-module>cd bigtop:spark
dtk:/service-module/bigtop:spark>list-assemblies
+------------+---------------+-------+---------------+
| ID         | ASSEMBLY NAME | NODES | DESCRIPTION   |
+------------+---------------+-------+---------------+
| 2147491121 | cluster       | 3     | spark cluster |
+------------+---------------+-------+---------------+
1 row in set

```
### Deploy assembly with name 'cluster' and name teh service instance spark-cluster1
```
dtk:/service-module/bigtop:spark>cd assembly/cluster
dtk:/service-module/bigtop:spark/assembly/cluster>deploy spark-cluster1
  2147491171
  assembly_instance_name: spark-cluster1
  task_id: 2147491402

```
### Navigate to 'service context to if new service is running'
```
dtk:/service-module/bigtop:spark/assembly/cluster>cd /service
dtk:/service>ls
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147491171 | spark-cluster1 | running | executing | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 02:03:51 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
1 row in set

```
