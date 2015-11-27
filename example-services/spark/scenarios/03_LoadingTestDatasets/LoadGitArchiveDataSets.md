## Loading a test data set (git archive)
# TODO: add text around captured screen shots
```
dtk:/service/spark-cluster1>cd master
dtk:/service/spark-cluster1/master>add-component datasets:gitarchive[mar01]
component_id: 2147495537
dtk:/service/spark-cluster1/master>cd ../
dtk:/service/spark-cluster1>list-violations
+--------------------------+-------------------------------------------------------------------+
| TYPE                     | DESCRIPTION                                                       |
+--------------------------+-------------------------------------------------------------------+
| required_unset_attribute | Attribute (master/gitarchive[mar01]/month) is required, but unset |
| required_unset_attribute | Attribute (master/gitarchive[mar01]/day) is required, but unset   |
+--------------------------+-------------------------------------------------------------------+
2 rows in set

dtk:/service/spark-cluster1>set-attribute master/gitarchive[mar01]/month 03
Status: OK
dtk:/service/spark-cluster1>set-attribute master/gitarchive[mar01]/day 01
Status: OK

```

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
| 2147495544 | master/gitarchive[mar01]/load_command_line      |                                                   | string  |
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
dtk:/service/spark-cluster1>list-workflows
+------------+----------------------------+
| ID         | WORKFLOW NAME              |
+------------+----------------------------+
| 2147495391 | clear_gitarchive_dataset   |
| 2147495392 | list_gitarchive_hdfs_files |
| 2147495390 | load_gitarchive_dataset    |
| 2147495389 | create                     |
+------------+----------------------------+
4 rows in set
```

```
dtk:/service/spark-cluster1>exec load_gitarchive_dataset name=mar01 -s
========================= start 'load_gitarchive_dataset' =========================


============================================================
STAGE 1: set 'mar01' dataset info
TIME START: 2015-11-27 16:55:04 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 2.6s
------------------------------------------------------------

============================================================
STAGE 2: load gitarchive 'mar01'
TIME START: 2015-11-27 16:55:07 +0000
ACTION: master/gitarchive[mar01].load
STATUS: succeeded
DURATION: 55.7s
RESULTS:

NODE: master
RUN: /usr/share/dtk/load_http_into_hdfs mar01 ec2-user 'http://data.githubarchive.org' /user/local/ec2-user/data/gitarchive/mar01
 (syscall)
RETURN CODE: 0
STDOUT:
  Loaded 24 files

------------------------------------------------------------

========================= end: 'load_gitarchive_dataset' (total duration: 58.7s) =========================
Status: OK
```
```
dtk:/service/spark-cluster1>exec list_gitarchive_hdfs_files name=mar01 -s
========================= start 'list_gitarchive_hdfs_files' =========================


============================================================
STAGE 1: set 'mar01' dataset info
TIME START: 2015-11-27 16:57:16 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 2.5s
------------------------------------------------------------

============================================================
STAGE 2: list 'mar01' hdfs files
TIME START: 2015-11-27 16:57:19 +0000
ACTION: master/gitarchive[mar01].list
STATUS: succeeded
DURATION: 2.0s
RESULTS:

NODE: master
RUN: su hdfs -c "hadoop fs -ls /user/local/ec2-user/data/gitarchive/mar01" (syscall)
RETURN CODE: 0
STDOUT:
  Found 24 items
  -rw-r--r--   3 ec2-user hadoop    5304518 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-0.json.gz
  -rw-r--r--   3 ec2-user hadoop    4393990 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-1.json.gz
  -rw-r--r--   3 ec2-user hadoop    4085536 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-10.json.gz
  -rw-r--r--   3 ec2-user hadoop    4491098 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-11.json.gz
  -rw-r--r--   3 ec2-user hadoop    4757573 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-12.json.gz
  -rw-r--r--   3 ec2-user hadoop    5207346 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-13.json.gz
  -rw-r--r--   3 ec2-user hadoop    5641287 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-14.json.gz
  -rw-r--r--   3 ec2-user hadoop    6070221 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-15.json.gz
  -rw-r--r--   3 ec2-user hadoop    8252093 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-16.json.gz
  -rw-r--r--   3 ec2-user hadoop    8625643 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-17.json.gz
  -rw-r--r--   3 ec2-user hadoop    6693715 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-18.json.gz
  -rw-r--r--   3 ec2-user hadoop    6831958 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-19.json.gz
  -rw-r--r--   3 ec2-user hadoop    4241119 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-2.json.gz
  -rw-r--r--   3 ec2-user hadoop    7449555 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-20.json.gz
  -rw-r--r--   3 ec2-user hadoop    7449225 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-21.json.gz
  -rw-r--r--   3 ec2-user hadoop    7312394 2015-11-27 16:56 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-22.json.gz
  -rw-r--r--   3 ec2-user hadoop    5988948 2015-11-27 16:56 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-23.json.gz
  -rw-r--r--   3 ec2-user hadoop    5258366 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-3.json.gz
  -rw-r--r--   3 ec2-user hadoop    4383413 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-4.json.gz
  -rw-r--r--   3 ec2-user hadoop    4190532 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-5.json.gz
  -rw-r--r--   3 ec2-user hadoop    5936092 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-6.json.gz
  -rw-r--r--   3 ec2-user hadoop    3456973 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-7.json.gz
  -rw-r--r--   3 ec2-user hadoop    3501737 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-8.json.gz
  -rw-r--r--   3 ec2-user hadoop    4050934 2015-11-27 16:55 /user/local/ec2-user/data/gitarchive/mar01/2015-03-01-9.json.gz

------------------------------------------------------------

========================= end: 'list_gitarchive_hdfs_files' (total duration: 4.8s) =========================
Status: OK
```
```
dtk:/service/spark-cluster1>exec load_gitarchive_dataset name=mar01 -s
========================= start 'load_gitarchive_dataset' =========================


============================================================
STAGE 1: set 'mar01' dataset info
TIME START: 2015-11-27 16:57:48 +0000
COMPONENT: master/gitarchive[mar01]
STATUS: succeeded
DURATION: 2.5s
------------------------------------------------------------

============================================================
STAGE 2: load gitarchive 'mar01'
TIME START: 2015-11-27 16:57:50 +0000
ACTION: master/gitarchive[mar01].load
STATUS: failed
DURATION: 2.0s
RESULTS:

NODE: master
RUN: /usr/share/dtk/load_http_into_hdfs mar01 ec2-user 'http://data.githubarchive.org' /user/local/ec2-user/data/gitarchive/mar01
 (syscall)
RETURN CODE: 1
STDOUT:
  Clear action needed on dataset 'mar01'

------------------------------------------------------------

========================= end: 'load_gitarchive_dataset' (total duration: 4.8s) =========================
Status: OK
```
```
dtk:/service/spark-cluster1>master ssh
You are entering SSH terminal (ec2-user@ec2-54-174-107-248.compute-1.amazonaws.com) ...
Warning: Permanently added 'ec2-54-174-107-248.compute-1.amazonaws.com,54.174.107.248' (ECDSA) to the list of known hosts.
Last login: Fri Nov 27 16:56:01 2015

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2015.09-release-notes/
5 package(s) needed for security, out of 28 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-90-0-22 ~]$ cd /usr/lib/spark
[ec2-user@ip-10-90-0-22 spark]$ bin/spark-shell
15/11/27 16:58:55 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.5.1
      /_/

Using Scala version 2.10.4 (OpenJDK 64-Bit Server VM, Java 1.7.0_91)
Type in expressions to have them evaluated.
Type :help for more information.
15/11/27 16:59:00 WARN MetricsSystem: Using default name DAGScheduler for source because spark.app.id is not set.
Spark context available as sc.
...
SQL context available as sqlContext.

scala> val df = sqlContext.read.json(sys.env("mar01"))
df: org.apache.spark.sql.DataFrame = [actor: struct<avatar_url:string,gravatar_id:string,id:bigint,login:string,url:string>, created_at: string, id: string, org: struct<avatar_url:string,gravatar_id:string,id:bigint,login:string,url:string>, payload: struct<action:string,before:string,comment:struct<_links:struct<html:struct<href:string>,pull_request:struct<href:string>,self:struct<href:string>>,body:string,commit_id:string,created_at:string,diff_hunk:string,html_url:string,id:bigint,issue_url:string,line:bigint,original_commit_id:string,original_position:bigint,path:string,position:bigint,pull_request_url:string,updated_at:string,url:string,user:struct<avatar_url:string,events_url:string,followers_url:string,following_url:string,gists_url:string,gravatar_id:string,html_url:string,id:bi...
scala> df.select("type").distinct.show
+--------------------+
|                type|
+--------------------+
|          WatchEvent|
|         IssuesEvent|
|PullRequestReview...|
|           PushEvent|
|           ForkEvent|
|         CreateEvent|
|         DeleteEvent|
|   IssueCommentEvent|
|  CommitCommentEvent|
|         MemberEvent|
|        ReleaseEvent|
|    PullRequestEvent|
|         PublicEvent|
|         GollumEvent|
+--------------------+

```
```
scala> df.printSchema
root
 |-- actor: struct (nullable = true)
 |    |-- avatar_url: string (nullable = true)
 |    |-- gravatar_id: string (nullable = true)
 |    |-- id: long (nullable = true)
 |    |-- login: string (nullable = true)
 |    |-- url: string (nullable = true)
 |-- created_at: string (nullable = true)
 |-- id: string (nullable = true)
 |-- org: struct (nullable = true)
 |    |-- avatar_url: string (nullable = true)
 |    |-- gravatar_id: string (nullable = true)
 |    |-- id: long (nullable = true)
 |    |-- login: string (nullable = true)
 |    |-- url: string (nullable = true)
 |-- payload: struct (nullable = true)
 |    |-- action: string (nullable = true)
 |    |-- before: string (nullable = true)
 |    |-- comment: struct (nullable = true)
 |    |    |-- _links: struct (nullable = true)
 |    |    |    |-- html: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- pull_request: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- self: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |-- body: string (nullable = true)
 |    |    |-- commit_id: string (nullable = true)
 |    |    |-- created_at: string (nullable = true)
 |    |    |-- diff_hunk: string (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- issue_url: string (nullable = true)
 |    |    |-- line: long (nullable = true)
 |    |    |-- original_commit_id: string (nullable = true)
 |    |    |-- original_position: long (nullable = true)
 |    |    |-- path: string (nullable = true)
 |    |    |-- position: long (nullable = true)
 |    |    |-- pull_request_url: string (nullable = true)
 |    |    |-- updated_at: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |    |-- user: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |-- commits: array (nullable = true)
 |    |    |-- element: struct (containsNull = true)
 |    |    |    |-- author: struct (nullable = true)
 |    |    |    |    |-- email: string (nullable = true)
 |    |    |    |    |-- name: string (nullable = true)
 |    |    |    |-- distinct: boolean (nullable = true)
 |    |    |    |-- message: string (nullable = true)
 |    |    |    |-- sha: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |-- description: string (nullable = true)
 |    |-- distinct_size: long (nullable = true)
 |    |-- forkee: struct (nullable = true)
 |    |    |-- archive_url: string (nullable = true)
 |    |    |-- assignees_url: string (nullable = true)
 |    |    |-- blobs_url: string (nullable = true)
 |    |    |-- branches_url: string (nullable = true)
 |    |    |-- clone_url: string (nullable = true)
 |    |    |-- collaborators_url: string (nullable = true)
 |    |    |-- comments_url: string (nullable = true)
 |    |    |-- commits_url: string (nullable = true)
 |    |    |-- compare_url: string (nullable = true)
 |    |    |-- contents_url: string (nullable = true)
 |    |    |-- contributors_url: string (nullable = true)
 |    |    |-- created_at: string (nullable = true)
 |    |    |-- default_branch: string (nullable = true)
 |    |    |-- description: string (nullable = true)
 |    |    |-- downloads_url: string (nullable = true)
 |    |    |-- events_url: string (nullable = true)
 |    |    |-- fork: boolean (nullable = true)
 |    |    |-- forks: long (nullable = true)
 |    |    |-- forks_count: long (nullable = true)
 |    |    |-- forks_url: string (nullable = true)
 |    |    |-- full_name: string (nullable = true)
 |    |    |-- git_commits_url: string (nullable = true)
 |    |    |-- git_refs_url: string (nullable = true)
 |    |    |-- git_tags_url: string (nullable = true)
 |    |    |-- git_url: string (nullable = true)
 |    |    |-- has_downloads: boolean (nullable = true)
 |    |    |-- has_issues: boolean (nullable = true)
 |    |    |-- has_pages: boolean (nullable = true)
 |    |    |-- has_wiki: boolean (nullable = true)
 |    |    |-- homepage: string (nullable = true)
 |    |    |-- hooks_url: string (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- issue_comment_url: string (nullable = true)
 |    |    |-- issue_events_url: string (nullable = true)
 |    |    |-- issues_url: string (nullable = true)
 |    |    |-- keys_url: string (nullable = true)
 |    |    |-- labels_url: string (nullable = true)
 |    |    |-- language: string (nullable = true)
 |    |    |-- languages_url: string (nullable = true)
 |    |    |-- merges_url: string (nullable = true)
 |    |    |-- milestones_url: string (nullable = true)
 |    |    |-- mirror_url: string (nullable = true)
 |    |    |-- name: string (nullable = true)
 |    |    |-- notifications_url: string (nullable = true)
 |    |    |-- open_issues: long (nullable = true)
 |    |    |-- open_issues_count: long (nullable = true)
 |    |    |-- owner: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- private: boolean (nullable = true)
 |    |    |-- public: boolean (nullable = true)
 |    |    |-- pulls_url: string (nullable = true)
 |    |    |-- pushed_at: string (nullable = true)
 |    |    |-- releases_url: string (nullable = true)
 |    |    |-- size: long (nullable = true)
 |    |    |-- ssh_url: string (nullable = true)
 |    |    |-- stargazers_count: long (nullable = true)
 |    |    |-- stargazers_url: string (nullable = true)
 |    |    |-- statuses_url: string (nullable = true)
 |    |    |-- subscribers_url: string (nullable = true)
 |    |    |-- subscription_url: string (nullable = true)
 |    |    |-- svn_url: string (nullable = true)
 |    |    |-- tags_url: string (nullable = true)
 |    |    |-- teams_url: string (nullable = true)
 |    |    |-- trees_url: string (nullable = true)
 |    |    |-- updated_at: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |    |-- watchers: long (nullable = true)
 |    |    |-- watchers_count: long (nullable = true)
 |    |-- head: string (nullable = true)
 |    |-- issue: struct (nullable = true)
 |    |    |-- assignee: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- body: string (nullable = true)
 |    |    |-- closed_at: string (nullable = true)
 |    |    |-- comments: long (nullable = true)
 |    |    |-- comments_url: string (nullable = true)
 |    |    |-- created_at: string (nullable = true)
 |    |    |-- events_url: string (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- labels: array (nullable = true)
 |    |    |    |-- element: struct (containsNull = true)
 |    |    |    |    |-- color: string (nullable = true)
 |    |    |    |    |-- name: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |-- labels_url: string (nullable = true)
 |    |    |-- locked: boolean (nullable = true)
 |    |    |-- milestone: struct (nullable = true)
 |    |    |    |-- closed_at: string (nullable = true)
 |    |    |    |-- closed_issues: long (nullable = true)
 |    |    |    |-- created_at: string (nullable = true)
 |    |    |    |-- creator: struct (nullable = true)
 |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |-- description: string (nullable = true)
 |    |    |    |-- due_on: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- labels_url: string (nullable = true)
 |    |    |    |-- number: long (nullable = true)
 |    |    |    |-- open_issues: long (nullable = true)
 |    |    |    |-- state: string (nullable = true)
 |    |    |    |-- title: string (nullable = true)
 |    |    |    |-- updated_at: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- number: long (nullable = true)
 |    |    |-- pull_request: struct (nullable = true)
 |    |    |    |-- diff_url: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- patch_url: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- state: string (nullable = true)
 |    |    |-- title: string (nullable = true)
 |    |    |-- updated_at: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |    |-- user: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |-- master_branch: string (nullable = true)
 |    |-- member: struct (nullable = true)
 |    |    |-- avatar_url: string (nullable = true)
 |    |    |-- events_url: string (nullable = true)
 |    |    |-- followers_url: string (nullable = true)
 |    |    |-- following_url: string (nullable = true)
 |    |    |-- gists_url: string (nullable = true)
 |    |    |-- gravatar_id: string (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- login: string (nullable = true)
 |    |    |-- organizations_url: string (nullable = true)
 |    |    |-- received_events_url: string (nullable = true)
 |    |    |-- repos_url: string (nullable = true)
 |    |    |-- site_admin: boolean (nullable = true)
 |    |    |-- starred_url: string (nullable = true)
 |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |-- type: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |-- number: long (nullable = true)
 |    |-- pages: array (nullable = true)
 |    |    |-- element: struct (containsNull = true)
 |    |    |    |-- action: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- page_name: string (nullable = true)
 |    |    |    |-- sha: string (nullable = true)
 |    |    |    |-- summary: string (nullable = true)
 |    |    |    |-- title: string (nullable = true)
 |    |-- pull_request: struct (nullable = true)
 |    |    |-- _links: struct (nullable = true)
 |    |    |    |-- comments: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- commits: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- html: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- issue: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- review_comment: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- review_comments: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- self: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |    |-- statuses: struct (nullable = true)
 |    |    |    |    |-- href: string (nullable = true)
 |    |    |-- additions: long (nullable = true)
 |    |    |-- assignee: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- base: struct (nullable = true)
 |    |    |    |-- label: string (nullable = true)
 |    |    |    |-- ref: string (nullable = true)
 |    |    |    |-- repo: struct (nullable = true)
 |    |    |    |    |-- archive_url: string (nullable = true)
 |    |    |    |    |-- assignees_url: string (nullable = true)
 |    |    |    |    |-- blobs_url: string (nullable = true)
 |    |    |    |    |-- branches_url: string (nullable = true)
 |    |    |    |    |-- clone_url: string (nullable = true)
 |    |    |    |    |-- collaborators_url: string (nullable = true)
 |    |    |    |    |-- comments_url: string (nullable = true)
 |    |    |    |    |-- commits_url: string (nullable = true)
 |    |    |    |    |-- compare_url: string (nullable = true)
 |    |    |    |    |-- contents_url: string (nullable = true)
 |    |    |    |    |-- contributors_url: string (nullable = true)
 |    |    |    |    |-- created_at: string (nullable = true)
 |    |    |    |    |-- default_branch: string (nullable = true)
 |    |    |    |    |-- description: string (nullable = true)
 |    |    |    |    |-- downloads_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- fork: boolean (nullable = true)
 |    |    |    |    |-- forks: long (nullable = true)
 |    |    |    |    |-- forks_count: long (nullable = true)
 |    |    |    |    |-- forks_url: string (nullable = true)
 |    |    |    |    |-- full_name: string (nullable = true)
 |    |    |    |    |-- git_commits_url: string (nullable = true)
 |    |    |    |    |-- git_refs_url: string (nullable = true)
 |    |    |    |    |-- git_tags_url: string (nullable = true)
 |    |    |    |    |-- git_url: string (nullable = true)
 |    |    |    |    |-- has_downloads: boolean (nullable = true)
 |    |    |    |    |-- has_issues: boolean (nullable = true)
 |    |    |    |    |-- has_pages: boolean (nullable = true)
 |    |    |    |    |-- has_wiki: boolean (nullable = true)
 |    |    |    |    |-- homepage: string (nullable = true)
 |    |    |    |    |-- hooks_url: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- issue_comment_url: string (nullable = true)
 |    |    |    |    |-- issue_events_url: string (nullable = true)
 |    |    |    |    |-- issues_url: string (nullable = true)
 |    |    |    |    |-- keys_url: string (nullable = true)
 |    |    |    |    |-- labels_url: string (nullable = true)
 |    |    |    |    |-- language: string (nullable = true)
 |    |    |    |    |-- languages_url: string (nullable = true)
 |    |    |    |    |-- merges_url: string (nullable = true)
 |    |    |    |    |-- milestones_url: string (nullable = true)
 |    |    |    |    |-- mirror_url: string (nullable = true)
 |    |    |    |    |-- name: string (nullable = true)
 |    |    |    |    |-- notifications_url: string (nullable = true)
 |    |    |    |    |-- open_issues: long (nullable = true)
 |    |    |    |    |-- open_issues_count: long (nullable = true)
 |    |    |    |    |-- owner: struct (nullable = true)
 |    |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |    |-- private: boolean (nullable = true)
 |    |    |    |    |-- pulls_url: string (nullable = true)
 |    |    |    |    |-- pushed_at: string (nullable = true)
 |    |    |    |    |-- releases_url: string (nullable = true)
 |    |    |    |    |-- size: long (nullable = true)
 |    |    |    |    |-- ssh_url: string (nullable = true)
 |    |    |    |    |-- stargazers_count: long (nullable = true)
 |    |    |    |    |-- stargazers_url: string (nullable = true)
 |    |    |    |    |-- statuses_url: string (nullable = true)
 |    |    |    |    |-- subscribers_url: string (nullable = true)
 |    |    |    |    |-- subscription_url: string (nullable = true)
 |    |    |    |    |-- svn_url: string (nullable = true)
 |    |    |    |    |-- tags_url: string (nullable = true)
 |    |    |    |    |-- teams_url: string (nullable = true)
 |    |    |    |    |-- trees_url: string (nullable = true)
 |    |    |    |    |-- updated_at: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |    |-- watchers: long (nullable = true)
 |    |    |    |    |-- watchers_count: long (nullable = true)
 |    |    |    |-- sha: string (nullable = true)
 |    |    |    |-- user: struct (nullable = true)
 |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |-- body: string (nullable = true)
 |    |    |-- changed_files: long (nullable = true)
 |    |    |-- closed_at: string (nullable = true)
 |    |    |-- comments: long (nullable = true)
 |    |    |-- comments_url: string (nullable = true)
 |    |    |-- commits: long (nullable = true)
 |    |    |-- commits_url: string (nullable = true)
 |    |    |-- created_at: string (nullable = true)
 |    |    |-- deletions: long (nullable = true)
 |    |    |-- diff_url: string (nullable = true)
 |    |    |-- head: struct (nullable = true)
 |    |    |    |-- label: string (nullable = true)
 |    |    |    |-- ref: string (nullable = true)
 |    |    |    |-- repo: struct (nullable = true)
 |    |    |    |    |-- archive_url: string (nullable = true)
 |    |    |    |    |-- assignees_url: string (nullable = true)
 |    |    |    |    |-- blobs_url: string (nullable = true)
 |    |    |    |    |-- branches_url: string (nullable = true)
 |    |    |    |    |-- clone_url: string (nullable = true)
 |    |    |    |    |-- collaborators_url: string (nullable = true)
 |    |    |    |    |-- comments_url: string (nullable = true)
 |    |    |    |    |-- commits_url: string (nullable = true)
 |    |    |    |    |-- compare_url: string (nullable = true)
 |    |    |    |    |-- contents_url: string (nullable = true)
 |    |    |    |    |-- contributors_url: string (nullable = true)
 |    |    |    |    |-- created_at: string (nullable = true)
 |    |    |    |    |-- default_branch: string (nullable = true)
 |    |    |    |    |-- description: string (nullable = true)
 |    |    |    |    |-- downloads_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- fork: boolean (nullable = true)
 |    |    |    |    |-- forks: long (nullable = true)
 |    |    |    |    |-- forks_count: long (nullable = true)
 |    |    |    |    |-- forks_url: string (nullable = true)
 |    |    |    |    |-- full_name: string (nullable = true)
 |    |    |    |    |-- git_commits_url: string (nullable = true)
 |    |    |    |    |-- git_refs_url: string (nullable = true)
 |    |    |    |    |-- git_tags_url: string (nullable = true)
 |    |    |    |    |-- git_url: string (nullable = true)
 |    |    |    |    |-- has_downloads: boolean (nullable = true)
 |    |    |    |    |-- has_issues: boolean (nullable = true)
 |    |    |    |    |-- has_pages: boolean (nullable = true)
 |    |    |    |    |-- has_wiki: boolean (nullable = true)
 |    |    |    |    |-- homepage: string (nullable = true)
 |    |    |    |    |-- hooks_url: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- issue_comment_url: string (nullable = true)
 |    |    |    |    |-- issue_events_url: string (nullable = true)
 |    |    |    |    |-- issues_url: string (nullable = true)
 |    |    |    |    |-- keys_url: string (nullable = true)
 |    |    |    |    |-- labels_url: string (nullable = true)
 |    |    |    |    |-- language: string (nullable = true)
 |    |    |    |    |-- languages_url: string (nullable = true)
 |    |    |    |    |-- merges_url: string (nullable = true)
 |    |    |    |    |-- milestones_url: string (nullable = true)
 |    |    |    |    |-- mirror_url: string (nullable = true)
 |    |    |    |    |-- name: string (nullable = true)
 |    |    |    |    |-- notifications_url: string (nullable = true)
 |    |    |    |    |-- open_issues: long (nullable = true)
 |    |    |    |    |-- open_issues_count: long (nullable = true)
 |    |    |    |    |-- owner: struct (nullable = true)
 |    |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |    |-- private: boolean (nullable = true)
 |    |    |    |    |-- pulls_url: string (nullable = true)
 |    |    |    |    |-- pushed_at: string (nullable = true)
 |    |    |    |    |-- releases_url: string (nullable = true)
 |    |    |    |    |-- size: long (nullable = true)
 |    |    |    |    |-- ssh_url: string (nullable = true)
 |    |    |    |    |-- stargazers_count: long (nullable = true)
 |    |    |    |    |-- stargazers_url: string (nullable = true)
 |    |    |    |    |-- statuses_url: string (nullable = true)
 |    |    |    |    |-- subscribers_url: string (nullable = true)
 |    |    |    |    |-- subscription_url: string (nullable = true)
 |    |    |    |    |-- svn_url: string (nullable = true)
 |    |    |    |    |-- tags_url: string (nullable = true)
 |    |    |    |    |-- teams_url: string (nullable = true)
 |    |    |    |    |-- trees_url: string (nullable = true)
 |    |    |    |    |-- updated_at: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |    |-- watchers: long (nullable = true)
 |    |    |    |    |-- watchers_count: long (nullable = true)
 |    |    |    |-- sha: string (nullable = true)
 |    |    |    |-- user: struct (nullable = true)
 |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- issue_url: string (nullable = true)
 |    |    |-- locked: boolean (nullable = true)
 |    |    |-- merge_commit_sha: string (nullable = true)
 |    |    |-- mergeable: boolean (nullable = true)
 |    |    |-- mergeable_state: string (nullable = true)
 |    |    |-- merged: boolean (nullable = true)
 |    |    |-- merged_at: string (nullable = true)
 |    |    |-- merged_by: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- milestone: struct (nullable = true)
 |    |    |    |-- closed_at: string (nullable = true)
 |    |    |    |-- closed_issues: long (nullable = true)
 |    |    |    |-- created_at: string (nullable = true)
 |    |    |    |-- creator: struct (nullable = true)
 |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |-- description: string (nullable = true)
 |    |    |    |-- due_on: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- labels_url: string (nullable = true)
 |    |    |    |-- number: long (nullable = true)
 |    |    |    |-- open_issues: long (nullable = true)
 |    |    |    |-- state: string (nullable = true)
 |    |    |    |-- title: string (nullable = true)
 |    |    |    |-- updated_at: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- number: long (nullable = true)
 |    |    |-- patch_url: string (nullable = true)
 |    |    |-- review_comment_url: string (nullable = true)
 |    |    |-- review_comments: long (nullable = true)
 |    |    |-- review_comments_url: string (nullable = true)
 |    |    |-- state: string (nullable = true)
 |    |    |-- statuses_url: string (nullable = true)
 |    |    |-- title: string (nullable = true)
 |    |    |-- updated_at: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |    |-- user: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |-- push_id: long (nullable = true)
 |    |-- pusher_type: string (nullable = true)
 |    |-- ref: string (nullable = true)
 |    |-- ref_type: string (nullable = true)
 |    |-- release: struct (nullable = true)
 |    |    |-- assets: array (nullable = true)
 |    |    |    |-- element: struct (containsNull = true)
 |    |    |    |    |-- browser_download_url: string (nullable = true)
 |    |    |    |    |-- content_type: string (nullable = true)
 |    |    |    |    |-- created_at: string (nullable = true)
 |    |    |    |    |-- download_count: long (nullable = true)
 |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |-- label: string (nullable = true)
 |    |    |    |    |-- name: string (nullable = true)
 |    |    |    |    |-- size: long (nullable = true)
 |    |    |    |    |-- state: string (nullable = true)
 |    |    |    |    |-- updated_at: string (nullable = true)
 |    |    |    |    |-- uploader: struct (nullable = true)
 |    |    |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |    |    |-- id: long (nullable = true)
 |    |    |    |    |    |-- login: string (nullable = true)
 |    |    |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |    |    |-- type: string (nullable = true)
 |    |    |    |    |    |-- url: string (nullable = true)
 |    |    |    |    |-- url: string (nullable = true)
 |    |    |-- assets_url: string (nullable = true)
 |    |    |-- author: struct (nullable = true)
 |    |    |    |-- avatar_url: string (nullable = true)
 |    |    |    |-- events_url: string (nullable = true)
 |    |    |    |-- followers_url: string (nullable = true)
 |    |    |    |-- following_url: string (nullable = true)
 |    |    |    |-- gists_url: string (nullable = true)
 |    |    |    |-- gravatar_id: string (nullable = true)
 |    |    |    |-- html_url: string (nullable = true)
 |    |    |    |-- id: long (nullable = true)
 |    |    |    |-- login: string (nullable = true)
 |    |    |    |-- organizations_url: string (nullable = true)
 |    |    |    |-- received_events_url: string (nullable = true)
 |    |    |    |-- repos_url: string (nullable = true)
 |    |    |    |-- site_admin: boolean (nullable = true)
 |    |    |    |-- starred_url: string (nullable = true)
 |    |    |    |-- subscriptions_url: string (nullable = true)
 |    |    |    |-- type: string (nullable = true)
 |    |    |    |-- url: string (nullable = true)
 |    |    |-- body: string (nullable = true)
 |    |    |-- created_at: string (nullable = true)
 |    |    |-- draft: boolean (nullable = true)
 |    |    |-- html_url: string (nullable = true)
 |    |    |-- id: long (nullable = true)
 |    |    |-- name: string (nullable = true)
 |    |    |-- prerelease: boolean (nullable = true)
 |    |    |-- published_at: string (nullable = true)
 |    |    |-- tag_name: string (nullable = true)
 |    |    |-- tarball_url: string (nullable = true)
 |    |    |-- target_commitish: string (nullable = true)
 |    |    |-- upload_url: string (nullable = true)
 |    |    |-- url: string (nullable = true)
 |    |    |-- zipball_url: string (nullable = true)
 |    |-- size: long (nullable = true)
 |-- public: boolean (nullable = true)
 |-- repo: struct (nullable = true)
 |    |-- id: long (nullable = true)
 |    |-- name: string (nullable = true)
 |    |-- url: string (nullable = true)
 |-- type: string (nullable = true)

```
