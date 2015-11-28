## Prerequisites
These examples assume that the user has a DTK server account, has installed a DTK client and has set up a deployment target (see ...)
They describe operation in the DTK shell", which is accessed by typing the following from a Linux console
```
user@host:~$ dtk-shell
dtk:/>
```
The DTK shell provides the interaction mode where the user can navigate to different contexts similiar to navigating to different directories in Linux using the cd command. The shell also provides context sensative help (by typing 'help') and command completion. In the examples in these writeups however we present the material so the user can cut and paste text and dont leverage for the most part the ability to navigate to child directories without giving full paths. For insance, in the examples we often navigate to a service instance and use 'spark-cluster1' as the example, in the text you might see teh following commands to cut and pastes
```
cd /service/spark-cluster1
list nodes
```
The actual user commands and DTK response would look like:

TODO: say that we often cd and use absuolte paths where if teh user was in teh .. context they woudl only have to type for example list nodes, like
