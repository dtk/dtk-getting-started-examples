## Load Data into hdfs
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
```
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

