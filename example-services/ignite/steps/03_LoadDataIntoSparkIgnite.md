## Load Data into HDFS, then create a shared RDD
TODO: below just has console screenshots; text will be added to explain

This page describes the steps to
* Using a DTK action to load a git archive datasetbinto HDFS
* Using Spark to load the git archive dataset in HDFS, which is gziped in json format, into a Spark Dataframe
* Creating an Ignite "Shared RDD" from this Spark dataframe
* Querying the Ignite shared RDD


In the [ignite assembly used to create this service instance] (https://github.com/dtk/getting-started-examples/blob/master/modules/service_modules/bigtop/ignite/assemblies/cluster.dtk.assembly.yaml) a sample dataset was explicitly included as captured by the assembly DSL fragment:
```
      - gitarchive[mar01]:
          attributes:
            owner: ec2-user
            year: 2015
            month: '03'
            day: '01'


```
This is in contrast to the [scenario we used for Spark] (https://github.com/dtk/getting-started-examples/blob/master/example-services/spark/scenarios/03_LoadingTestDatasets/LoadGitArchiveDataSets.md) where the base assembly did not explicitly include a dataset and therefore user needed to first explicitly add a dataset by adding a DTK component.

To see the set of actions available in the "ignite-cluster1" service instance the user can navigate to this service instance context and invoke the "list-workflows" command:
```
dtk:/service/ignite-cluster1>list-workflows
+------------+-------------------------------+
| ID         | WORKFLOW NAME                 |
+------------+-------------------------------+
| 2147495782 | create                        |
| 2147495783 | ignite_daemon_status          |
| 2147495784 | restart_ignite_daemons        |
| 2147495785 | hdfs_load_gitarchive_dataset  |
| 2147495786 | hdfs_clear_gitarchive_dataset |
| 2147495787 | hdfs_list_gitarchive_files    |
| 2147495788 | create_shared_spark_rdd       |
+------------+-------------------------------+
7 rows in set
```

The user can then invoke the "hdfs_load_gitarchive_dataset" action on the dataset named "mar01" by using the following command:
dtk:/service/ignite-cluster1>exec hdfs_load_gitarchive_dataset name=mar01 -s
========================= start 'hdfs_load_gitarchive_dataset' =========================


============================================================
STAGE 1: set 'mar01' dataset info
TIME START: 2015-11-27 17:29:35 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 2.4s
------------------------------------------------------------

============================================================
STAGE 2: load gitarchive 'mar01'
TIME START: 2015-11-27 17:29:38 +0000
ACTION: master/gitarchive[mar01].load
STATUS: succeeded
DURATION: 60.0s
RESULTS:

NODE: master
RUN: /usr/share/dtk/load_http_into_hdfs mar01 ec2-user 'http://data.githubarchive.org' /user/local/ec2-user/data/gitarchive/mar01
 (syscall)
RETURN CODE: 0
STDOUT:
  Loaded 24 files

------------------------------------------------------------

========================= end: 'hdfs_load_gitarchive_dataset' (total duration: 62.6s) =========================
Status: OK

```
## Log into master Node and work in spark shell
```
TO create an Ignite shared RDD we show steps where the user logs into the Spark she'll on the master node. (Note: an enhancement to the DTK assembly that will be shortly implemented will use a DTK action to create the shared RDD)

The steps below shows logging into the master node and then entering the spark she'll. the command line options on the spark-shell command are to [load in the Ignite jars using its "maven coordinates"] (http://apacheignite.gridgain.org/docs/testing-integration-with-spark-shell) along with loading in a jar with classes that are dynamically compiled by the DTK workflow that created the Ignite cluster (note: currently as an example two classes are dynamically created, one called Actor and another called Repo; added notes will be given about [use of a hash definition] (https://github.com/dtk/getting-started-examples/blob/master/modules/component_modules/bigtop/ignite/manifests/params/cache_object_meta_info.pp) that is input to have the DTK dynamically create the desired Java classes that represent the type of the Ignite face values)
```
dtk:/service/ignite-cluster1>master ssh
You are entering SSH terminal (ec2-user@ec2-54-164-28-171.compute-1.amazonaws.com) ...
Warning: Permanently added 'ec2-54-164-28-171.compute-1.amazonaws.com,54.164.28.171' (ECDSA) to the list of known hosts.
Last login: Fri Nov 27 17:30:34 2015

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2015.09-release-notes/
5 package(s) needed for security, out of 28 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-90-0-220 ~]$ cd /usr/lib/spark
[ec2-user@ip-10-90-0-220 spark]$ ./bin/spark-shell \
>   --packages org.apache.ignite:ignite-spark:1.4.0 \
>   --repositories http://www.gridgainsystems.com/nexus/content/repositories/external \
>   --jars /usr/lib/ignite/libs/ignite-cache-objects.jar
Ivy Default Cache set to: /home/ec2-user/.ivy2/cache
The jars for the packages stored in: /home/ec2-user/.ivy2/jars
http://www.gridgainsystems.com/nexus/content/repositories/external added as a remote repository with the name: repo-1
:: loading settings :: url = jar:file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/spark-assembly-1.5.1-hadoop2.6.0.jar!/org/apache/ivy/core/settings/ivysettings.xml
org.apache.ignite#ignite-spark added as a dependency
:: resolving dependencies :: org.apache.spark#spark-submit-parent;1.0
        confs: [default]
        found org.apache.ignite#ignite-spark;1.4.0 in central
        found org.apache.ignite#ignite-core;1.4.0 in central
        found javax.cache#cache-api;1.0.0 in central
        found org.gridgain#ignite-shmem;1.0.0 in central
        found org.apache.ignite#ignite-indexing;1.4.0 in central
        found commons-codec#commons-codec;1.6 in central
        found org.apache.lucene#lucene-core;3.5.0 in central
        found com.h2database#h2;1.3.175 in central
        found org.apache.ignite#ignite-spring;1.4.0 in central
        found org.springframework#spring-core;4.1.0.RELEASE in central
        found org.springframework#spring-aop;4.1.0.RELEASE in central
        found aopalliance#aopalliance;1.0 in central
        found org.springframework#spring-beans;4.1.0.RELEASE in central
        found org.springframework#spring-context;4.1.0.RELEASE in central
        found org.springframework#spring-expression;4.1.0.RELEASE in central
        found org.springframework#spring-tx;4.1.0.RELEASE in central
        found org.springframework#spring-jdbc;4.1.0.RELEASE in central
        found commons-logging#commons-logging;1.1.1 in central
        found org.apache.ignite#ignite-log4j;1.4.0 in central
        found log4j#log4j;1.2.17 in central
downloading https://repo1.maven.org/maven2/org/apache/ignite/ignite-spark/1.4.0/ignite-spark-1.4.0.jar ...
        [SUCCESSFUL ] org.apache.ignite#ignite-spark;1.4.0!ignite-spark.jar (6ms)
...
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.5.1
      /_/

Using Scala version 2.10.4 (OpenJDK 64-Bit Server VM, Java 1.7.0_91)
Type in expressions to have them evaluated.
....

scala> import org.apache.ignite._
import org.apache.ignite._

scala> import org.apache.ignite.configuration._
import org.apache.ignite.configuration._

scala> import org.apache.ignite.cache.query._
import org.apache.ignite.cache.query._

scala> import org.apache.ignite.spark._
import org.apache.ignite.spark._

scala> import org.apache.ignite.lang.IgniteBiPredicate
import org.apache.ignite.lang.IgniteBiPredicate

scala> import io.dtk._
import io.dtk._

scala> val df = sqlContext.read.json(sys.env("mar01"))
df: org.apache.spark.sql.DataFrame = [actor: struct<avatar_url:string,gravatar_id:string,id:bigint,login:string,url:string>, created_at: string, id: string, org: struct<avatar_url:string,gravatar_id:string,id:bigint,login:string,url:string>, payload: struct<action:string,before:string,comment:struct<_links:struct<html:struct<href:string>,pull_request:struct<href:string>,self:struct<href:string>>,body:string,commit_id:string,created_at:string,diff_hunk:string,html_url:string,id:bigint,issue_url:string,line:bigint,original_commit_id:string,original_position:bigint,path:string,position:bigint,pull_request_url:string,updated_at:string,url:string,user:struct<avatar_url:string,events_url:string,followers_url:string,following_url:string,gists_url:string,gravatar_id:string,html_url:string,id:bi...
scala> val rdd = df.select("actor.id","actor.avatar_url","actor.gravatar_id","actor.url","actor.login","actor.id").
     |      map(row => (row.getLong(0).toString, new Actor(row.getString(1),row.getString(2),row.getString(3),row.getString(4),row.getLong(5))))
rdd: org.apache.spark.rdd.RDD[(String, io.dtk.Actor)] = MapPartitionsRDD[12] at map at <console>:38

scala> Ignition.setClientMode(true)

scala> val cacheName = "actor"
cacheName: String = actor

scala> val cfg = new CacheConfiguration[String,Actor]().setName(cacheName).setIndexedTypes(classOf[String],classOf[Actor]).setLoadPreviousValue(true)
cfg: org.apache.ignite.configuration.CacheConfiguration[String,io.dtk.Actor] = CacheConfiguration [name=actor, rebalancePoolSize=2, rebalanceTimeout=10000, evictPlc=null, evictSync=false, evictKeyBufSize=1024, evictSyncConcurrencyLvl=4, evictSyncTimeout=10000, evictFilter=null, evictMaxOverflowRatio=10.0, eagerTtl=true, dfltLockTimeout=0, startSize=1500000, nearCfg=null, writeSync=null, storeFactory=null, loadPrevVal=true, aff=null, cacheMode=PARTITIONED, atomicityMode=null, atomicWriteOrderMode=null, backups=0, invalidate=false, tmLookupClsName=null, rebalanceMode=ASYNC, rebalanceOrder=0, rebalanceBatchSize=524288, offHeapMaxMem=-1, swapEnabled=false, maxConcurrentAsyncOps=500, writeBehindEnabled=false, writeBehindFlushSize=10240, writeBehindFlushFreq=5000, writeBehindFlushThreadCnt=1,...
scala> val ic = new IgniteContext[String,Actor](sc, "/usr/lib/ignite/config/config.xml")
15/11/27 17:44:39 WARN NoopCheckpointSpi: Checkpoints are disabled (to enable configure any GridCheckpointSpi implementation)
15/11/27 17:44:39 WARN GridCollisionManager: Collision resolution is disabled (all jobs will be activated upon arrival).
15/11/27 17:44:39 WARN NoopSwapSpaceSpi: Swap space is disabled. To enable use FileSwapSpaceSpi.
ic: org.apache.ignite.spark.IgniteContext[String,io.dtk.Actor] = org.apache.ignite.spark.IgniteContext@6da4e0b1

scala> val sharedRDD = ic.fromCache(cfg)
sharedRDD: org.apache.ignite.spark.IgniteRDD[String,io.dtk.Actor] = IgniteRDD[13] at RDD at IgniteAbstractRDD.scala:31

scala> sharedRDD.savePairs(rdd)

scala>
     | sharedRDD.sql("select login, count(*) from Actor group by login limit 5").show
+-----------+--------+
|      LOGIN|COUNT(*)|
+-----------+--------+
|   webwurst|       1|
|   jsf62592|       1|
|r0t0r-r0t0r|       1|
|      seebs|       1|
|  mmagnuski|       1|
+-----------+--------+
```
```
scala> exit
warning: there were 1 deprecation warning(s); re-run with -deprecation for details
[ec2-user@ip-10-90-0-220 spark]$ ./bin/spark-shell   --packages org.apache.ignite:ignite-spark:1.4.0   --repositories http://www.gridgainsystems.com/nexus/content/repositories/external   --jars /usr/lib/ignite/libs/ignite-cache-objects.jar
Ivy Default Cache set to: /home/ec2-user/.ivy2/cache
The jars for the packages stored in: /home/ec2-user/.ivy2/jars
http://www.gridgainsystems.com/nexus/content/repositories/external added as a remote repository with the name: repo-1
:: loading settings :: url = jar:file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/spark-assembly-1.5.1-hadoop2.6.0.jar!/org/apache/ivy/core/settings/ivysettings.xml
org.apache.ignite#ignite-spark added as a dependency
:: resolving dependencies :: org.apache.spark#spark-submit-parent;1.0
        confs: [default]
        found org.apache.ignite#ignite-spark;1.4.0 in central
        found org.apache.ignite#ignite-core;1.4.0 in central
        found javax.cache#cache-api;1.0.0 in central
        found org.gridgain#ignite-shmem;1.0.0 in central
        found org.apache.ignite#ignite-indexing;1.4.0 in central
        found commons-codec#commons-codec;1.6 in central
        found org.apache.lucene#lucene-core;3.5.0 in central
        found com.h2database#h2;1.3.175 in central
        found org.apache.ignite#ignite-spring;1.4.0 in central
        found org.springframework#spring-core;4.1.0.RELEASE in central
        found org.springframework#spring-aop;4.1.0.RELEASE in central
        found aopalliance#aopalliance;1.0 in central
        found org.springframework#spring-beans;4.1.0.RELEASE in central
        found org.springframework#spring-context;4.1.0.RELEASE in central
        found org.springframework#spring-expression;4.1.0.RELEASE in central
        found org.springframework#spring-tx;4.1.0.RELEASE in central
        found org.springframework#spring-jdbc;4.1.0.RELEASE in central
        found commons-logging#commons-logging;1.1.1 in central
        found org.apache.ignite#ignite-log4j;1.4.0 in central
        found log4j#log4j;1.2.17 in central
:: resolution report :: resolve 1188ms :: artifacts dl 27ms
        :: modules in use:
        aopalliance#aopalliance;1.0 from central in [default]
        com.h2database#h2;1.3.175 from central in [default]
        commons-codec#commons-codec;1.6 from central in [default]
        commons-logging#commons-logging;1.1.1 from central in [default]
        javax.cache#cache-api;1.0.0 from central in [default]
        log4j#log4j;1.2.17 from central in [default]
        org.apache.ignite#ignite-core;1.4.0 from central in [default]
        org.apache.ignite#ignite-indexing;1.4.0 from central in [default]
        org.apache.ignite#ignite-log4j;1.4.0 from central in [default]
        org.apache.ignite#ignite-spark;1.4.0 from central in [default]
        org.apache.ignite#ignite-spring;1.4.0 from central in [default]
        org.apache.lucene#lucene-core;3.5.0 from central in [default]
        org.gridgain#ignite-shmem;1.0.0 from central in [default]
        org.springframework#spring-aop;4.1.0.RELEASE from central in [default]
        org.springframework#spring-beans;4.1.0.RELEASE from central in [default]
        org.springframework#spring-context;4.1.0.RELEASE from central in [default]
        org.springframework#spring-core;4.1.0.RELEASE from central in [default]
        org.springframework#spring-expression;4.1.0.RELEASE from central in [default]
        org.springframework#spring-jdbc;4.1.0.RELEASE from central in [default]
        org.springframework#spring-tx;4.1.0.RELEASE from central in [default]
        :: evicted modules:
        commons-logging#commons-logging;1.1.3 by [commons-logging#commons-logging;1.1.1] in [default]
        ---------------------------------------------------------------------
        |                  |            modules            ||   artifacts   |
        |       conf       | number| search|dwnlded|evicted|| number|dwnlded|
        ---------------------------------------------------------------------
        |      default     |   21  |   0   |   0   |   1   ||   20  |   0   |
        ---------------------------------------------------------------------
:: retrieving :: org.apache.spark#spark-submit-parent
        confs: [default]
        0 artifacts copied, 20 already retrieved (0kB/18ms)
15/11/27 17:46:09 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.5.1
      /_/

Using Scala version 2.10.4 (OpenJDK 64-Bit Server VM, Java 1.7.0_91)
Type in expressions to have them evaluated.
Type :help for more information.
15/11/27 17:46:15 WARN MetricsSystem: Using default name DAGScheduler for source because spark.app.id is not set.
Spark context available as sc.
15/11/27 17:46:17 WARN General: Plugin (Bundle) "org.datanucleus.store.rdbms" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark/lib/datanucleus-rdbms-3.2.9.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-rdbms-3.2.9.jar."
15/11/27 17:46:17 WARN General: Plugin (Bundle) "org.datanucleus" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark/lib/datanucleus-core-3.2.10.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-core-3.2.10.jar."
15/11/27 17:46:17 WARN General: Plugin (Bundle) "org.datanucleus.api.jdo" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-api-jdo-3.2.6.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark/lib/datanucleus-api-jdo-3.2.6.jar."
15/11/27 17:46:18 WARN Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
15/11/27 17:46:18 WARN Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
15/11/27 17:46:23 WARN ObjectStore: Version information not found in metastore. hive.metastore.schema.verification is not enabled so recording the schema version 1.2.0
15/11/27 17:46:23 WARN ObjectStore: Failed to get database default, returning NoSuchObjectException
15/11/27 17:46:24 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
15/11/27 17:46:25 WARN General: Plugin (Bundle) "org.datanucleus.store.rdbms" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark/lib/datanucleus-rdbms-3.2.9.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-rdbms-3.2.9.jar."
15/11/27 17:46:25 WARN General: Plugin (Bundle) "org.datanucleus" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark/lib/datanucleus-core-3.2.10.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-core-3.2.10.jar."
15/11/27 17:46:25 WARN General: Plugin (Bundle) "org.datanucleus.api.jdo" is already registered. Ensure you dont have multiple JAR versions of the same plugin in the classpath. The URL "file:/usr/lib/spark-1.5.1-bin-hadoop2.6/lib/datanucleus-api-jdo-3.2.6.jar" is already registered, and you are trying to register an identical plugin located at URL "file:/usr/lib/spark/lib/datanucleus-api-jdo-3.2.6.jar."
15/11/27 17:46:25 WARN Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
15/11/27 17:46:25 WARN Connection: BoneCP specified but not present in CLASSPATH (or one of dependencies)
SQL context available as sqlContext.
```
```
scala> import org.apache.ignite._
import org.apache.ignite._

scala> import org.apache.ignite.configuration._
import org.apache.ignite.configuration._

scala> import org.apache.ignite.cache.query._
import org.apache.ignite.cache.query._

scala> import org.apache.ignite.spark._
import org.apache.ignite.spark._

scala> import org.apache.ignite.lang.IgniteBiPredicate
import org.apache.ignite.lang.IgniteBiPredicate

scala> import io.dtk._
import io.dtk._

scala> Ignition.setClientMode(true)

scala> val cacheName = "actor"
cacheName: String = actor

scala> val cfg = new CacheConfiguration[String,Actor]().setName(cacheName).setIndexedTypes(classOf[String],classOf[Actor]).setLoadPreviousValue(true)
cfg: org.apache.ignite.configuration.CacheConfiguration[String,io.dtk.Actor] = CacheConfiguration [name=actor, rebalancePoolSize=2, rebalanceTimeout=10000, evictPlc=null, evictSync=false, evictKeyBufSize=1024, evictSyncConcurrencyLvl=4, evictSyncTimeout=10000, evictFilter=null, evictMaxOverflowRatio=10.0, eagerTtl=true, dfltLockTimeout=0, startSize=1500000, nearCfg=null, writeSync=null, storeFactory=null, loadPrevVal=true, aff=null, cacheMode=PARTITIONED, atomicityMode=null, atomicWriteOrderMode=null, backups=0, invalidate=false, tmLookupClsName=null, rebalanceMode=ASYNC, rebalanceOrder=0, rebalanceBatchSize=524288, offHeapMaxMem=-1, swapEnabled=false, maxConcurrentAsyncOps=500, writeBehindEnabled=false, writeBehindFlushSize=10240, writeBehindFlushFreq=5000, writeBehindFlushThreadCnt=1,...
scala> val ic = new IgniteContext[String,Actor](sc, "/usr/lib/ignite/config/config.xml")
15/11/27 17:47:46 WARN NoopCheckpointSpi: Checkpoints are disabled (to enable configure any GridCheckpointSpi implementation)
15/11/27 17:47:46 WARN GridCollisionManager: Collision resolution is disabled (all jobs will be activated upon arrival).
15/11/27 17:47:46 WARN NoopSwapSpaceSpi: Swap space is disabled. To enable use FileSwapSpaceSpi.
ic: org.apache.ignite.spark.IgniteContext[String,io.dtk.Actor] = org.apache.ignite.spark.IgniteContext@20eff29a

scala> val sharedRDD = ic.fromCache(cfg)
sharedRDD: org.apache.ignite.spark.IgniteRDD[String,io.dtk.Actor] = IgniteRDD[0] at RDD at IgniteAbstractRDD.scala:31

scala> sharedRDD.sql("select login, count(*) from Actor group by login limit 5").show
+-----------+--------+
|      LOGIN|COUNT(*)|
+-----------+--------+
|   webwurst|       1|
|   jsf62592|       1|
|r0t0r-r0t0r|       1|
|      seebs|       1|
|  mmagnuski|       1|
+-----------+--------+


scala>
```

```
scala> import org.apache.ignite._
import org.apache.ignite._

scala> import org.apache.ignite.configuration._
import org.apache.ignite.configuration._

scala> import org.apache.ignite.cache.query._
import org.apache.ignite.cache.query._

scala> import org.apache.ignite.spark._
import org.apache.ignite.spark._

scala> import org.apache.ignite.lang.IgniteBiPredicate
import org.apache.ignite.lang.IgniteBiPredicate

scala> import io.dtk._
import io.dtk._

scala> //Actor(avatar_url: String, gravatar_id: String, id: Long, login: String, url: String)

scala>
     | Ignition.setClientMode(true)

scala> val ignite = Ignition.start("/usr/lib/ignite/config/config.xml")
15/11/27 17:49:49 WARN NoopCheckpointSpi: Checkpoints are disabled (to enable configure any GridCheckpointSpi implementation)
15/11/27 17:49:49 WARN GridCollisionManager: Collision resolution is disabled (all jobs will be activated upon arrival).
15/11/27 17:49:49 WARN NoopSwapSpaceSpi: Swap space is disabled. To enable use FileSwapSpaceSpi.
ignite: org.apache.ignite.Ignite = IgniteKernal [cfg=IgniteConfiguration [gridName=null, pubPoolSize=16, sysPoolSize=16, mgmtPoolSize=4, igfsPoolSize=2, utilityCachePoolSize=16, utilityCacheKeepAliveTime=10000, marshCachePoolSize=16, marshCacheKeepAliveTime=10000, p2pPoolSize=2, ggHome=null, ggWork=null, mbeanSrv=com.sun.jmx.mbeanserver.JmxMBeanServer@2ad21854, nodeId=51deeaf8-3453-4d16-909f-3b845dcb2e35, marsh=org.apache.ignite.marshaller.optimized.OptimizedMarshaller@36a76cf9, marshLocJobs=false, daemon=false, p2pEnabled=false, netTimeout=5000, sndRetryDelay=1000, sndRetryCnt=3, clockSyncSamples=8, clockSyncFreq=120000, metricsHistSize=10000, metricsUpdateFreq=2000, metricsExpTime=9223372036854775807, discoSpi=TcpDiscoverySpi [addrRslvr=null, sockTimeout=5000, ackTimeout=5000, reconCn...
scala> val cacheName = "actor"
cacheName: String = actor

scala> val cfg = new CacheConfiguration[String,Actor]().setName(cacheName).setIndexedTypes(classOf[Integer],classOf[Actor]).setLoadPreviousValue(true)
cfg: org.apache.ignite.configuration.CacheConfiguration[String,io.dtk.Actor] = CacheConfiguration [name=actor, rebalancePoolSize=2, rebalanceTimeout=10000, evictPlc=null, evictSync=false, evictKeyBufSize=1024, evictSyncConcurrencyLvl=4, evictSyncTimeout=10000, evictFilter=null, evictMaxOverflowRatio=10.0, eagerTtl=true, dfltLockTimeout=0, startSize=1500000, nearCfg=null, writeSync=null, storeFactory=null, loadPrevVal=true, aff=null, cacheMode=PARTITIONED, atomicityMode=null, atomicWriteOrderMode=null, backups=0, invalidate=false, tmLookupClsName=null, rebalanceMode=ASYNC, rebalanceOrder=0, rebalanceBatchSize=524288, offHeapMaxMem=-1, swapEnabled=false, maxConcurrentAsyncOps=500, writeBehindEnabled=false, writeBehindFlushSize=10240, writeBehindFlushFreq=5000, writeBehindFlushThreadCnt=1,...
scala> val cache =  ignite.getOrCreateCache[String,Actor](cfg)
cache: org.apache.ignite.IgniteCache[String,io.dtk.Actor] = IgniteCacheProxy [delegate=GridDhtAtomicCache [updateReplyClos=org.apache.ignite.internal.processors.cache.distributed.dht.atomic.GridDhtAtomicCache$2@5bfeef84, near=null, super=GridDhtCacheAdapter [multiTxHolder=java.lang.ThreadLocal@1623e5d4, super=GridDistributedCacheAdapter [super=GridCacheAdapter [valCheck=true, aff=org.apache.ignite.internal.processors.cache.affinity.GridCacheAffinityImpl@86a3b6d, igfsDataCache=false, mongoDataCache=false, mongoMetaCache=false, igfsDataCacheSize=null, igfsDataSpaceMax=0, asyncOpsSem=java.util.concurrent.Semaphore@7663756b[Permits = 500], name=actor, size=0]]]], opCtx=null]

scala>
     | cache.query(new SqlFieldsQuery("select login, count(*) from Actor group by login limit 5")).getAll
res3: java.util.List[java.util.List[_]] = [[webwurst, 1], [McKnas, 1], [r0t0r-r0t0r, 1], [mmagnuski, 1], [seebs, 1]]

scala>

```
