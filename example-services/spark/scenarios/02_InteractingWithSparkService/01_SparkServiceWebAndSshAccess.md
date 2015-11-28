## Internet Access for Spark Service
After a service instance is deployed, if the user wants to access the service from the Internet, the user can use the 'list-nodes' command to see the host address that each node is on:
```
dtk:/service/spark-cluster1>list-nodes
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| ID         | NAME     | INSTANCE ID | SIZE      | OS           | OP STATUS | DNS NAME                                  |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
| 2147493838 | master   | i-5cfe95ec  | t2.medium | amazon-linux | running   | ec2-54-88-11-179.compute-1.amazonaws.com  |
| 2147493998 | slaves:1 | i-e8fd9658  | t2.medium | amazon-linux | running   | ec2-54-88-67-35.compute-1.amazonaws.com   |
| 2147493999 | slaves:2 | i-5efe95ee  | t2.medium | amazon-linux | running   | ec2-54-86-215-188.compute-1.amazonaws.com |
+------------+----------+-------------+-----------+--------------+-----------+-------------------------------------------+
3 rows in set
```
For the case of spark to view cluster status thd user can connect to the master node on port 8080, i.e., using the url:
```
http://ec2-54-88-11-179.compute-1.amazonaws.com:8080
```
The user must make sure that the security group associated with the target (see ...) has the appropriate ports open for access. So in this case the user would need to make sure that the desktop with the browser can connect on port 8080; if not the user will need to log into the EC2 console and open this port. To get more information about node 'master' including its security group the user can issue the following command:
```
dtk:/service/spark-cluster1>master info
---
 node_id: 2147493838
 os_type: amazon-linux
 admin_op_status: running
 image_id: ami-b40b4ede
 type: ec2_instance
 size: t2.medium
 instance_id: i-5cfe95ec
 ec2_public_address: ec2-54-88-11-179.compute-1.amazonaws.com
 keypair: rich-vpc1
 security_groups: memcore-public
 target: vpc-us-east-1

```
## SSH Access
If the user wants to ssh into a node, he or she can either use the node's host address as shown above, making sure that port 22 is open or can directly ssh into the node after copying the the ssh pem file to the machine with the dtk client. In this example we assume that the user is logged in as 'user1' when accessing the DTK shell. The user should copy the pem to location
```
/home/user1/dtk/dtk.pem
```
and make sure permissions are set as 600:
```
user1@dhost:~$ ls -l /home/dtk614-rich/dtk/dtk.pem
-rw------- 1 user1 user1 1696 Nov 20 02:22 /home/user1/dtk/dk.pem
```
With this pem in place the user can simply execute the following 'ssh' command to gain ssh access. So to log into the 'master' node the user could execute the following:
```
dtk:/service/spark-cluster1>master ssh
You are entering SSH terminal (ec2-user@ec2-54-88-11-179.compute-1.amazonaws.com) ...
Warning: Permanently added 'ec2-54-88-11-179.compute-1.amazonaws.com,54.88.11.179' (ECDSA) to the list of known hosts.
Last login: Tue Nov 17 14:02:26 2015 from 80.65.165.170

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2015.09-release-notes/
5 package(s) needed for security, out of 28 available
Run "sudo yum update" to apply all updates.

```
On the other had if the user wanted to log into node 'slaves:1', the following could be executed:


```
dtk:/service/spark-cluster1>slaves:1 ssh
You are entering SSH terminal (ec2-user@ec2-54-88-67-35.compute-1.amazonaws.com) ...
...
```
When the user after loging into a remote node doe an exit, the user wil be put back in the DTK shell from the place where they invoked the shell:
```
[ec2-user@ip-10-90-0-238 spark]$ cd
[ec2-user@ip-10-90-0-238 ~]$ exit
logout
Connection to ec2-54-88-11-179.compute-1.amazonaws.com closed.
You are leaving SSH terminal, and returning to DTK Shell ...
dtk:/service/spark-cluster1>

```

If the user had different pem files for different nodes then the following command option could be used
```
NODE ssh -i ABSOLUTE-PATH-TO-PEM
```
In the examples above the login user is omitted. The DTK shell tries to automatically figure out the login user if omitted; so in this example for an Amazon Linux node the DTK server would use 'ec2-user' as default. The user can also specifically give the login user with the syntax
```
NODE ssh -i LOGIN-USER [-i ABSOLUTE-PATH-TO-PEM]
```

## Accessing the Spark Shell
For the spark cluster that is spun up in this example the user can enter the spark shell by executing the following commands:
```
dtk:/service/spark-cluster1>master ssh
You are entering SSH terminal (ec2-user@ec2-54-88-11-179.compute-1.amazonaws.com) ...
Warning: Permanently added 'ec2-54-88-11-179.compute-1.amazonaws.com,54.88.11.179' (ECDSA) to the list of known hosts.
Last login: Fri Nov 27 05:22:58 2015 from ec2-54-211-59-126.compute-1.amazonaws.com

       __|  __|_  )
       _|  (     /   Amazon Linux AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-ami/2015.09-release-notes/
5 package(s) needed for security, out of 28 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-10-90-0-238 ~]$ cd /usr/lib/spark
[ec2-user@ip-10-90-0-238 spark]$ bin/spark-shell
15/11/27 05:29:59 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 1.5.1
      /_/

Using Scala version 2.10.4 (OpenJDK 64-Bit Server VM, Java 1.7.0_91)
Type in expressions to have them evaluated.
Type :help for more information.
15/11/27 05:30:05 WARN MetricsSystem: Using default name DAGScheduler for source because spark.app.id is not set.
Spark context available as sc.
...
```
