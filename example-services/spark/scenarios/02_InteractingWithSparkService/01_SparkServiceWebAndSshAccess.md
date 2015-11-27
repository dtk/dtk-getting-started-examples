## Internet Access for Spark Service
After a service instance is deployed, if the user wants to access the service from the Internet, the user can use the 'list-nodes' command to see the host address that each node is on. Below is an example that shows the 'list-nodes' command for the 'spark-cluster1' command:
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
For the case of spark to view cluster status teh user can connect to the master node on port 8080, i.e., using the url:
```
http://ec2-54-88-11-179.compute-1.amazonaws.com:8080
```
The user most make sure that the security group associated with the target (see ...) has the appropriate ports open for access. So in this case the user would need to make sure that the desktop with the browser can connect on port 8080; if not the user will need to log into the EC2 console and open this port. To get more information about node 'master' including its security group the user can issue the following command:
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
