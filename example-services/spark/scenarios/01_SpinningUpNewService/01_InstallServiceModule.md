## Install the Spark service module
In order to deploy a services using the DevOps Toolkit (DTK), a service module must first be installed from the DTK Catalog Manager. The steps below show installation of a sample service module that is used to deploy a cluster that runs Spark in native cluster mode and HDFS. It has a topology with one master node and a set of slave/worker nodes that by default is set to 2, but as illustrated in a later scenario can be initially  or scaled to the desired size.

We assume that the user first entered the DTK shell from the Linux command line
```
user@host:~$ dtk-shell
dtk:/>
```
In these Spark scenarios we will use a service module named 'bigtop:spark'. To install this service module into the user's local environment the following commands can be enterred after enterring the DTK shell:
**Cut-and-paste**


```
cd /service-module
install bigtop:spark

```
The first command navigates to the "service module context" and the second command does the actual installation. The dialog with the user's commands and the DTK responses will look like:
```
dtk:/>cd /service-module
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
```
This output shows both the installation of the bigtop:spark service module as well as the installation of all the "component modules" that it refers to. In these exercises we will not dig into the details of component modules, which can be thought of as the reusable building blocks for forming services.

The user can list the currently installed service modules with the commands:
```
cd /service-module
ls
```
which in this scenario would show output:
```
+------------+--------------+---------------------+------------+
| ID         | NAME         | REMOTE(S)           | DSL PARSED |
+------------+--------------+---------------------+------------+
| 2147491114 | bigtop:spark | dtkn://bigtop/spark | true       |
+------------+--------------+---------------------+------------+
1 row in set
```
Note: as explained in the perrequsite section we wil be giving cut and patse commands that make no assumption about what context the user is in the dtk shell. See these cut and paste fragments will typically start with 'cd /FULLPATH'. If the user wants to take advatage of the DTK shell contecxt mechanism, if teh user ws already in the 'serce-module; context, they simply can do 'ls' as shown below
```
dtk:/service-module>ls
+------------+--------------+---------------------+------------+
| ID         | NAME         | REMOTE(S)           | DSL PARSED |
+------------+--------------+---------------------+------------+
| 2147491114 | bigtop:spark | dtkn://bigtop/spark | true       |
+------------+--------------+---------------------+------------+
1 row in set
```
```
If the user wants to see teh currently installed component modules, teh following commands can be used:
```
cd /component-module
ls

```

The output would look like:
+------------+----------------------------+-------------------------------------------------------------------------+------------+
| ID         | NAME                       | REMOTE(S)                                                               | DSL PARSED |
+------------+----------------------------+-------------------------------------------------------------------------+------------+
| 2147491096 | bigtop-new:bigtop_base     | dtkn://bigtop-new/bigtop_base                                           | true       |
| 2147490947 | bigtop-new:hadoop          | dtkn://bigtop-new/hadoop                                                | true       |
| 2147490855 | bigtop-new:spark           | dtkn://bigtop-new/spark                                                 | true       |
| 2147491068 | bigtop:bigtop_multiservice | dtkn://bigtop/bigtop_multiservice                                       | true       |
| 2147490664 | bigtop:bigtop_toolchain    | dtkn://bigtop/bigtop_toolchain                                          | true       |
| 2147490703 | bigtop:dataset             | dtkn://bigtop/dataset                                                   | true       |
| 2147490647 | bigtop:kerberos            | dtkn://bigtop/kerberos                                                  | true       |
| 2147491042 | datasets:gitarchive        | dtkn://datasets/gitarchive                                              | true       |
| 2147490253 | dtk:dtk_util               | dtkn://dtk/dtk_util                                                     | true       |
| 2147490841 | dtk:host                   | dtkn://dtk/host                                                         | true       |
| 2147490732 | maestrodev:maven           | dtkn://maestrodev/maven, http://github.com/maestrodev/puppet-maven      | true       |
| 2147490187 | maestrodev:wget            | dtkn://maestrodev/wget, https://github.com/maestrodev/puppet-wget.git   | true       |
| 2147490281 | puppetlabs:stdlib          | dtkn://puppetlabs/stdlib, git://github.com/puppetlabs/puppetlabs-stdlib | true       |
+------------+----------------------------+-------------------------------------------------------------------------+------------+
13 rows in set
```
