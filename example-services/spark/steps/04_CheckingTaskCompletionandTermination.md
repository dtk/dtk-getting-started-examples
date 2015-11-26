## Checking Task Completion
Task completion can be checked in a number of different ways. Using the 'task-status' command the user can determine whether the task is complete. Below is an example of a task that completed in seuccess
```
dtk:/service/spark-cluster1>task-status
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| TASK TYPE                        | STATUS    | NODE          | DURATION | STARTED AT        | ENDED AT          |
+----------------------------------+-----------+---------------+----------+-------------------+-------------------+
| assembly_converge                | succeeded |               | 318.6s   | 17:16:55 26/11/15 | 17:22:13 26/11/15 |
|   1 create_nodes_stage           | succeeded |               | 83.8s    | 17:16:55 26/11/15 | 17:18:18 26/11/15 |
|     1.1 create_node              | succeeded | master        | 82.0s    | 17:16:55 26/11/15 | 17:18:17 26/11/15 |
|     1.2 create_node              | succeeded | slaves:1      | 83.8s    | 17:16:55 26/11/15 | 17:18:18 26/11/15 |
|     1.3 create_node              | succeeded | slaves:2      | 82.8s    | 17:16:55 26/11/15 | 17:18:17 26/11/15 |
|   2 bigtop_multiservice          | succeeded |               | 0.0s     | 17:18:19 26/11/15 | 17:18:19 26/11/15 |
|     2.1 configure_node           | succeeded | assembly_wide | 0.0s     | 17:18:19 26/11/15 | 17:18:19 26/11/15 |
|   3 bigtop hiera                 | succeeded |               | 5.4s     | 17:18:29 26/11/15 | 17:18:35 26/11/15 |
|     3.1 configure_nodegroup      | succeeded | slaves        | 5.3s     | 17:18:29 26/11/15 | 17:18:35 26/11/15 |
|       3.1.1 configure_node       | succeeded | slaves:1      | 3.4s     | 17:18:29 26/11/15 | 17:18:33 26/11/15 |
|       3.1.2 configure_node       | succeeded | slaves:2      | 3.1s     | 17:18:31 26/11/15 | 17:18:35 26/11/15 |
...
```
The top level row 'assembly' converge' indicates the summary status of the task as a whole.
As an alternative, to see the status of all the service instances the user can do a list command at the service level context by issing the following commands:
```
cd /service
ls

```
The results can look like
```
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147493837 | spark-cluster1 | running | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 17:16:53 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
1 row in set

```
The 'LAST RUN' column shows the status of the last run task. The 'STATUS' column indicates whether the service instance is powered on ('running'), powered off ('stopped') or staged and not yet executed ('pending').
As an example of a scenario where along with 'spark-cluster1' the user  also staged but did not yet execute a second spark cluster 'spark-cluster2'
```
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| ID         | ASSEMBLY NAME  | STATUS  | LAST RUN  | ASSEMBLY TEMPLATE             | TARGET        | # NODES | CREATED AT        |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
| 2147493837 | spark-cluster1 | running | succeeded | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 17:16:53 26/11/15 |
| 2147494146 | spark-cluster2 | pending |           | bigtop:spark/assembly/cluster | vpc-us-east-1 | 3       | 18:03:51 26/11/15 |
+------------+----------------+---------+-----------+-------------------------------+---------------+---------+-------------------+
```
Since no tasks have been run yet for 'spark-cluster2' teh cloun 'LAST RUN' has no value
