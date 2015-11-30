# Getting started Ignite cluster example 
These scenarios over deployment of a cluster that has Apace Ignite, Spark and HDFS running and shows an example of 
* Using a DTK action to load a git archive datasetbinto HDFS
* Using Spark to load the git archive dataset in HDFS, which is gziped in json format, into a Spark Dataframe
* Creating an Ignite "Shared RDD" from this Spark dataframe
* Querying the Ignite shared RDD

It is assumed that user is familiar with the DTK concepts covered in the Spark example
