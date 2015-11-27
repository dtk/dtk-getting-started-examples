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

class bigtop_toolchain::groovy {

 $groovy_dir = '/usr/local/groovy'
 
 # TODO: will refactor so each tool brings in what it needs
 #  include bigtop_toolchain::packages

  exec {"/usr/bin/wget http://dl.bintray.com/groovy/maven/groovy-binary-2.4.0.zip":
    cwd     => "/usr/src",
#    require => Package[$packages::pkgs],
    unless  => "/usr/bin/test -f /usr/src/groovy-binary-2.4.0.zip",
  }

  exec {'/usr/bin/unzip -x -o /usr/src/groovy-binary-2.4.0.zip':
    cwd         => '/usr/local',
    refreshonly => true,
    subscribe   => Exec["/usr/bin/wget http://dl.bintray.com/groovy/maven/groovy-binary-2.4.0.zip"],
    require     => Exec["/usr/bin/wget http://dl.bintray.com/groovy/maven/groovy-binary-2.4.0.zip"],
  }

  file { $groovy_dir: 
    ensure  => link,
    target  => '/usr/local/groovy-2.4.0',
    require => Exec['/usr/bin/unzip -x -o /usr/src/groovy-binary-2.4.0.zip'],
  }
}
