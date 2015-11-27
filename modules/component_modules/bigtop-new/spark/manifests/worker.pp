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

class spark::worker() inherits spark::common
{

  spark::install::component {'worker':
    before => Class['spark::config']
  }

  include spark::config

  unless $master_ec2_local_ipv4 == undef {
    host { $master_host:
      ensure => 'present',
      ip     => $master_ec2_local_ipv4,
      before => Service['spark-worker'],
      notify => Service['spark-worker']
    }
  }

  service { 'spark-worker':
    ensure     => running,
    enable     => true,
    require    => Class['spark::config'], 
    subscribe  => [Spark::Install::Component['worker'], Class['spark::config']],
    hasrestart => true,
    hasstatus  => true,
  } 
}
