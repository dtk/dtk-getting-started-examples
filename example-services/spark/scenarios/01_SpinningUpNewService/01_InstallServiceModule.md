## Install the Spark service module
In order to deploy a services using the DevOps Toolkit (DTK), service modules must first be installed from the DTK Catalog Manager. The steps below shows installation of a service module that can deploy spark clusters.

In the text below and throughout the examples we provide both the commands in a form so they can be cut and paste along with the full interactive session with user commands and the DTK responses. We assume that user first entered the DTK shell from the Linux command line
```
user@host:~$ dtk-shell
dtk:/>
```

**Cut-and-paste**

Navigate to service module context and then install the service module 'bigtop:spark'
```
cd /service-module
install bigtop:spark

```
List the service modules to show the installed service module and then navigate to the component module context to show the component modules that get installed as dependencies when installing the service module.
```
ls
cd /component-module
ls

```

**Commands and responses**
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
module_directory: /home/dtk614-rich/dtk/service_modules/bigtop/spark

dtk:/service-module>ls
+------------+--------------+---------------------+------------+
| ID         | NAME         | REMOTE(S)           | DSL PARSED |
+------------+--------------+---------------------+------------+
| 2147491114 | bigtop:spark | dtkn://bigtop/spark | true       |
+------------+--------------+---------------------+------------+
1 row in set

dtk:/service-module>cd /component-module
dtk:/component-module>ls
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
