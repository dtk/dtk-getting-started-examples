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

class spark::config() inherits spark::common
{

  $link_base = "${spark_dir}/conf"

  spark::config::file { ['spark-env.sh', 'spark-defaults.conf', 'log4j.properties']: }
}

define spark::config::file()
{

  $config_file      = $name
  $config_file_path = "${spark::config::spark_conf_dir}/${config_file}"

  # template variables
  $master_host        = $spark::config::master_host
  $master_port        = $spark::config::master_port
  $master_ui_port     = $spark::config::master_ui_port
  $spark_public_dns   = $spark::config::spark_public_dns
  $cassandra_host     = $spark::config::cassandra_host
  $hdfs_namenode_host = $spark::config::hdfs_namenode_host

  file { $config_file_path:
    content => template("spark/conf/${config_file}.erb")
  }

  $link_path = "${spark::config::link_base}/${config_file}"
  unless $config_file_path == $link_path {
    file { $link_path:
      ensure  => 'link',
      target  => $config_file_path,
      require => File[$config_file_path]
    }
  }
}


