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

class spark::master(
  $master_port,
  $master_ui_port,
  $eventlog_enabled,
  $history_server_enabled = undef,
  $eventlog_dir           = undef,
  $hdfs_working_dirs      = undef,
  $hdfs_namenode_host     = undef,
  $cassandra_host         = undef
) 
{
  include spark::params
  $spark_version = $spark::params::spark_version

  # assuming $spark_version of form x.y.z; stripping off
  $stripped_spark_version = inline_template("<%= @spark_version.gsub(/\.[0-9]+$/,'') %>")
  $num_spark_version = 0 + $stripped_spark_version 
  if $num_spark_version > 1.3 {
   $master_host = $::ipaddress
  } else {
   $master_host = $::fqdn
  }

  $master_ec2_local_ipv4 = $::ec2_local_ipv4  
  r8::export_variable { 'spark::master::spark_version': } 
  r8::export_variable { 'spark::master::master_host': }
  r8::export_variable { 'spark::master::master_ec2_local_ipv4': }

  spark::install::component { 'master':
    before => Class['spark::config']
  }

  if $history_server_enabled {
    include spark::history_server
  } 

  include spark::config

  service { 'spark-master':
    ensure     => running,
    enable     => true,
    require    => Class['spark::config'],
    subscribe  => [Spark::Install::Component['master'], Class['spark::config']],
    hasrestart => true,
    hasstatus  => true,
  }
}
