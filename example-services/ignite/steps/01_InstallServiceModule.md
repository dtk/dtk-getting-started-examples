## Install the Ignite service module
We assume that user first entered the dtk shell from the LInux command line
```
user@host:~$ dtk-shell
dtk:/>
```


To install an ignite cluster, the user should navigate to the service module context and then use the install command, selecting the service module 'bigtop:ignite'. In text below we show the DTK response if the ignite service module is being installed in a context where the spark service module has already been installed. Installing Spark is not necessary;  it just impacts the prompts from the DTK server. In our example scenario the user will see the following prompt:
```
Do you want to update dependent component module 'maestrodev:wget' from the catalog? (yes/no/all/none):
```
This prompt will be produced if service module being installed has dependent component modules that are common to ones loaded already. This prompt will appear for each dependent component module that is already installed unless 'none' or 'all' is selecetd which is a user response for all dependent modules (see .. for discussion on updating shared modules)
So to install ignite, user can cut and paste
```
cd /service-module
install bigtop:ignite
none

```
The full commands and responses will look like:
```
dtk:/>cd /service-module
dtk:/service-module>cd /service-module
dtk:/service-module>install bigtop:ignite
Auto-installing missing module(s)
Using component module 'maestrodev:wget'
Do you want to update dependent component module 'maestrodev:wget' from the catalog? (yes/no/all/none): none
Using component module 'dtk:dtk_util'
Using component module 'puppetlabs:stdlib'
Using component module 'bigtop:kerberos'
Using component module 'bigtop:bigtop_toolchain'
Using component module 'maestrodev:maven'
Using component module 'bigtop:dataset'
Using component module 'dtk:host'
Using component module 'bigtop-new:spark'
Using component module 'bigtop-new:hadoop'
Using component module 'datasets:gitarchive'
Using component module 'bigtop:bigtop_multiservice'
Using component module 'bigtop-new:bigtop_base'
Installing component module 'bigtop:ignite' ... Done.
Resuming DTK Network import for service_module 'bigtop:ignite' ... Done
module_directory: /home/dtk614-rich/dtk/service_modules/bigtop/ignite
```
