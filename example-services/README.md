## Prerequisites
These examples assume that the user has a DTK server account, has installed a DTK client and has set up a deployment target (see ...).
The user should start with the Spark scenarios. The ignite examples assume familiarity with concepts introduced in the Spark scenarios.

These examplesndescribe operations in the "DTK shell", which is accessed by typing the following from a Linux console
```
user@host:~$ dtk-shell
dtk:/>
```
The DTK shell provides the interaction mode where the user can navigate to different contexts similiar to navigating to different directories in Linux using the cd command. The shell also provides context sensative help (by typing 'help') and command completion. In the examples in these writeups however we present the material so the user can cut and paste text and we don't make any assumptions about which context the user is starting from when entering commands; so you will see cut and paste text that often begins with a cd command with a full path like 
```
cd /service/spark-cluster1
list-nodes
```
If we knew what context the user was in before showing this example text we would often be able to,omit the cd command; so for example if we knew user was already in the "/service/spark-cluster1" context, the instructions to list its nodes would simply by to type 'list-nodes'
