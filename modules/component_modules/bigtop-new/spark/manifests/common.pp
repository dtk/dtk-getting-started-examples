# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class spark::common(
  $master_host           = dtk_util_select_value('spark::master::master_host'),
  $master_port           = dtk_util_select_value('spark::master::master_port'),
  $master_ui_port        = dtk_util_select_value('spark::master::master_ui_port'),
  $eventlog_enabled      = dtk_util_select_value('spark::master::eventlog_enabled'),
  $eventlog_dir          = dtk_util_select_value('spark::master::eventlog_dir'),
  $cassandra_host        = dtk_util_select_value('spark::master::cassandra_host'),
  $hdfs_namenode_host    = dtk_util_select_value('spark::master::hdfs_namenode_host'),
  $master_ec2_local_ipv4 = undef,
  

) inherits spark::params
{
  $spark_public_dns = $::ec2_public_hostname
  
  # TODO: push this info in, arther than assuming spark master on hdfs master
  $hdfs_master_host = $master_host
}

