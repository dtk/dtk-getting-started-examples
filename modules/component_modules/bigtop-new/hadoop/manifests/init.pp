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

class hadoop ($hadoop_security_authentication = "simple",
  $zk = "",
  # Set from facter if available
  $hadoop_storage_base_dirs = [],
  $hadoop_storage_dirs = split($::hadoop_storage_dirs, ";"),
  $proxyusers = {
    oozie => { groups => 'hudson,testuser,root,hadoop,jenkins,oozie,httpfs,hue,users', hosts => "*" },
                  hue => { groups => 'hudson,testuser,root,hadoop,jenkins,oozie,httpfs,hue,users', hosts => "*" },
               httpfs => { groups => 'hudson,testuser,root,hadoop,jenkins,oozie,httpfs,hue,users', hosts => "*" } } ) {

  include stdlib
  include bigtop_base

  file { $hadoop::hadoop_storage_base_dirs:
    ensure => 'directory'    
  }
  file { $hadoop::hadoop_storage_dirs:
    ensure => 'directory',    
    require => File[$hadoop::hadoop_storage_base_dirs]
  }

  /**
   * Common definitions for hadoop nodes.
   * They all need these files so we can access hdfs/jobs from any node
   */
   
  class kerberos {
    require kerberos::client

    kerberos::host_keytab { "hdfs":
      princs => [ "host", "hdfs" ],
      spnego => true,
      require => Package["hadoop-hdfs"],
    }
   
    kerberos::host_keytab { [ "yarn", "mapred" ]:
      tag    => "mapreduce",
      spnego => true,
      require => Package["hadoop-yarn"],
    }
  }

  class common ($hadoop_java_home = undef,
      $hadoop_classpath = undef,
      $hadoop_heapsize = undef,
      $hadoop_opts = undef,
      $hadoop_namenode_opts = undef,
      $hadoop_secondarynamenode_opts = undef,
      $hadoop_datanode_opts = undef,
      $hadoop_balancer_opts = undef,
      $hadoop_jobtracker_opts = undef,
      $hadoop_tasktracker_opts = undef,
      $hadoop_client_opts = undef,
      $hadoop_ssh_opts = undef,
      $hadoop_log_dir = undef,
      $hadoop_slaves = undef,
      $hadoop_master = undef,
      $hadoop_slave_sleep = undef,
      $hadoop_pid_dir = undef,
      $hadoop_ident_string = undef,
      $hadoop_niceness = undef,
      $hadoop_security_authentication = $hadoop::hadoop_security_authentication ) inherits hadoop {

    if ($hadoop_security_authentication == "kerberos") {
      include hadoop::kerberos
    }

    file {
      "/etc/hadoop/conf/hadoop-env.sh":
        content => template('hadoop/hadoop-env.sh'),
        require => [Package["hadoop"]],
    }

    package { "hadoop":
      ensure => latest,
      require => Package["jdk"],
    }

    #FIXME: package { "hadoop-native":
    #  ensure => latest,
    #  require => [Package["hadoop"]],
    #}
  }

  class common_yarn (
      $yarn_data_dirs = suffix($hadoop::hadoop_storage_dirs, "/yarn"),
      $kerberos_realm = undef,
      $hadoop_ps_host = $::fqdn,
      $hadoop_ps_port = "20888",
      $hadoop_rm_host = $::fqdn,
      $hadoop_rm_port = "8032",
      $hadoop_rm_admin_port = "8033",
      $hadoop_rm_webapp_port = "8088",
      $hadoop_rt_port = "8025",
      $hadoop_sc_port = "8030",
      $yarn_nodemanager_resource_memory_mb = undef,
      $yarn_scheduler_maximum_allocation_mb = undef,
      $yarn_scheduler_minimum_allocation_mb = undef,
      $yarn_resourcemanager_scheduler_class = undef,
      $yarn_resourcemanager_ha_enabled = undef,
      $yarn_resourcemanager_cluster_id = "ha-rm-uri",
      $yarn_resourcemanager_zk_address = $hadoop::zk) inherits hadoop {

    include common_hdfs

    package { "hadoop-yarn":
      ensure => latest,
      require => [Package["jdk"], Package["hadoop"]],
    }
 
    file {
      "/etc/hadoop/conf/yarn-site.xml":
        content => template('hadoop/yarn-site.xml'),
        require => [Package["hadoop"]],
    }

    file { "/etc/hadoop/conf/container-executor.cfg":
      content => template('hadoop/container-executor.cfg'), 
      require => [Package["hadoop"]],
    }
  }

  class common_hdfs ($ha = "disabled",
      $hadoop_config_dfs_block_size = undef,
      $hadoop_config_namenode_handler_count = undef,
      $hadoop_dfs_datanode_plugins = "",
      $hadoop_dfs_namenode_plugins = "",
      $hadoop_namenode_host = $fqdn,
      $hadoop_namenode_port = "8020",
      $hadoop_namenode_http_port = "50070",
      $hadoop_namenode_https_port = "50470",
      $hdfs_data_dirs = suffix($hadoop::hadoop_storage_dirs, "/hdfs"),
      $hdfs_shortcut_reader_user = undef,
      $hdfs_support_append = undef,
      $hdfs_webhdfs_enabled = "true",
      $hdfs_replication = undef,
      $hdfs_datanode_fsdataset_volume_choosing_policy = undef,
      $namenode_data_dirs = suffix($hadoop::hadoop_storage_dirs, "/namenode"),
      $nameservice_id = "ha-nn-uri",
      $journalnode_host = "0.0.0.0",
      $journalnode_port = "8485",
      $journalnode_http_port = "8480",
      $journalnode_https_port = "8481",
      $journalnode_edits_dir = "${hadoop::hadoop_storage_dirs[0]}/journalnode",
      $shared_edits_dir = "/hdfs_shared",
      $testonly_hdfs_sshkeys  = "no",
      $hadoop_ha_sshfence_user_home = "/var/lib/hadoop-hdfs",
      $sshfence_user = "hdfs",
      $zk = $hadoop::zk,
      $hadoop_config_fs_inmemory_size_mb = undef,
      $hadoop_security_group_mapping = undef,
      $hadoop_core_proxyusers = $hadoop::proxyusers,
      $hadoop_snappy_codec = undef,
      $hadoop_security_authentication = $hadoop::hadoop_security_authentication ) inherits hadoop {

    $sshfence_keydir  = "$hadoop_ha_sshfence_user_home/.ssh"
    $sshfence_keypath = "$sshfence_keydir/id_sshfence"
    $sshfence_privkey = hiera("hadoop::common_hdfs::sshfence_privkey", "hadoop/id_sshfence")
    $sshfence_pubkey  = hiera("hadoop::common_hdfs::sshfence_pubkey", "hadoop/id_sshfence.pub")

    include common

  # Check if test mode is enforced, so we can install hdfs ssh-keys for passwordless
    if ($testonly_hdfs_sshkeys == "yes") {
      notify{"WARNING: provided hdfs ssh keys are for testing purposes only.\n
        They shouldn't be used in production cluster": }
      $ssh_user        = "hdfs"
      $ssh_user_home   = "/var/lib/hadoop-hdfs"
      $ssh_user_keydir = "$ssh_user_home/.ssh"
      $ssh_keypath     = "$ssh_user_keydir/id_hdfsuser"
      $ssh_privkey     = "hdfs/id_hdfsuser"
      $ssh_pubkey      = "hdfs/id_hdfsuser.pub"

      file { $ssh_user_keydir:
        ensure  => directory,
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0700',
        require => Package["hadoop-hdfs"],
      }

      file { $ssh_keypath:
        source  => "puppet:///files/$ssh_privkey",
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0600',
        require => File[$ssh_user_keydir],
      }

      file { "$ssh_user_keydir/authorized_keys":
        source  => "puppet:///files/$ssh_pubkey",
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0600',
        require => File[$ssh_user_keydir],
      }
    }
    if ($hadoop_security_authentication == "kerberos" and $ha != "disabled") {
      fail("High-availability secure clusters are not currently supported")
    }

    package { "hadoop-hdfs":
      ensure => latest,
      require => [Package["jdk"], Package["hadoop"]],
    }
 
    file {
      "/etc/hadoop/conf/core-site.xml":
        content => template('hadoop/core-site.xml'),
        require => [Package["hadoop"]],
    }

    file {
      "/etc/hadoop/conf/hdfs-site.xml":
        content => template('hadoop/hdfs-site.xml'),
        require => [Package["hadoop"]],
    }
  }

  class common_mapred
  {
    package { "hadoop-mapreduce":
      ensure => latest,
      require => [Package["jdk"], Package["hadoop"]],
    }
  }

  class common_mapred_app (
      $hadoop_config_io_sort_factor = undef,
      $hadoop_config_io_sort_mb = undef,
      $hadoop_config_mapred_child_ulimit = undef,
      $hadoop_config_mapred_fairscheduler_assignmultiple = undef,
      $hadoop_config_mapred_fairscheduler_sizebasedweight = undef,
      $hadoop_config_mapred_job_tracker_handler_count = undef,
      $hadoop_config_mapred_reduce_parallel_copies = undef,
      $hadoop_config_mapred_reduce_slowstart_completed_maps = undef,
      $hadoop_config_mapred_reduce_tasks_speculative_execution = undef,
      $hadoop_config_tasktracker_http_threads = undef,
      $hadoop_config_use_compression = undef,
      $hadoop_hs_host = undef,
      $hadoop_hs_port = "10020",
      $hadoop_hs_webapp_port = "19888",
      $hadoop_jobtracker_fairscheduler_weightadjuster = undef,
      $hadoop_jobtracker_host,
      $hadoop_jobtracker_port = "8021",
      $hadoop_jobtracker_taskscheduler = undef,
      $hadoop_mapred_jobtracker_plugins = "",
      $hadoop_mapred_tasktracker_plugins = "",
      $mapred_acls_enabled = undef,
      $mapred_data_dirs = suffix($hadoop::hadoop_storage_dirs, "/mapred")) inherits common_mapred {

    include common_hdfs

      file {
      "/etc/hadoop/conf/mapred-site.xml":
        content => template('hadoop/mapred-site.xml'),
        require => [Package["hadoop"]],
    }

    file { "/etc/hadoop/conf/taskcontroller.cfg":
      content => template('hadoop/taskcontroller.cfg'), 
      require => [Package["hadoop"]],
    }
  }

  class datanode {
    include common_hdfs

    package { "hadoop-hdfs-datanode":
      ensure => latest,
      require => Package["jdk"],
    }

    file {
      "/etc/default/hadoop-hdfs-datanode":
        content => template('hadoop/hadoop-hdfs'),
        require => [Package["hadoop-hdfs-datanode"]],
    }

    service { "hadoop-hdfs-datanode":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-hdfs-datanode"], File["/etc/hadoop/conf/core-site.xml"], File["/etc/hadoop/conf/hdfs-site.xml"], File["/etc/hadoop/conf/hadoop-env.sh"]],
      require => [ Package["hadoop-hdfs-datanode"], File["/etc/default/hadoop-hdfs-datanode"], File[$hadoop::common_hdfs::hdfs_data_dirs] ],
    }
    Kerberos::Host_keytab <| title == "hdfs" |> -> Exec <| tag == "namenode-format" |> -> Service["hadoop-hdfs-datanode"]

    file { $hadoop::common_hdfs::hdfs_data_dirs:
      ensure => directory,
      owner => hdfs,
      group => hdfs,
      mode => 755,
      require => [ Package["hadoop-hdfs"] ],
    }
  }

  class httpfs ($hadoop_httpfs_port = "14000",
      $secret = "hadoop httpfs secret",
      $hadoop_core_proxyusers = $hadoop::proxyusers,
      $hadoop_security_authentcation = $hadoop::hadoop_security_authentication ) inherits hadoop {

    if ($hadoop_security_authentication == "kerberos") {
      kerberos::host_keytab { "httpfs":
        spnego => true,
        require => Package["hadoop-httpfs"],
      }
    }

    package { "hadoop-httpfs":
      ensure => latest,
      require => Package["jdk"],
    }

    file { "/etc/hadoop-httpfs/conf/httpfs-site.xml":
      content => template('hadoop/httpfs-site.xml'),
      require => [Package["hadoop-httpfs"]],
    }

    file { "/etc/hadoop-httpfs/conf/httpfs-env.sh":
      content => template('hadoop/httpfs-env.sh'),
      require => [Package["hadoop-httpfs"]],
    }

    file { "/etc/hadoop-httpfs/conf/httpfs-signature.secret":
      content => inline_template("<%= @secret %>"),
      require => [Package["hadoop-httpfs"]],
    }

    service { "hadoop-httpfs":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-httpfs"], File["/etc/hadoop-httpfs/conf/httpfs-site.xml"], File["/etc/hadoop-httpfs/conf/httpfs-env.sh"], File["/etc/hadoop-httpfs/conf/httpfs-signature.secret"]],
      require => [ Package["hadoop-httpfs"] ],
    }
    Kerberos::Host_keytab <| title == "httpfs" |> -> Service["hadoop-httpfs"]
  }

  class kinit {
    include hadoop::kerberos

    exec { "HDFS kinit":
      command => "/usr/bin/kinit -kt /etc/hdfs.keytab hdfs/$fqdn && /usr/bin/kinit -R",
      user    => "hdfs",
      require => Kerberos::Host_keytab["hdfs"],
    }
  }

  class create_hdfs_dirs($hdfs_dirs_meta,
      $hadoop_security_authentcation = $hadoop::hadoop_security_authentication ) inherits hadoop {
    $user = $hdfs_dirs_meta[$title][user]
    $perm = $hdfs_dirs_meta[$title][perm]

    if ($hadoop_security_authentication == "kerberos") {
      require hadoop::kinit
      Exec["HDFS kinit"] -> Exec["HDFS init $title"]
    }

    exec { "HDFS init $title":
      user => "hdfs",
      command => "/bin/bash -c 'hadoop fs -mkdir $title ; hadoop fs -chmod $perm $title && hadoop fs -chown $user $title'",
      require => Service["hadoop-hdfs-namenode"],
    }
    Exec <| title == "activate nn1" |>  -> Exec["HDFS init $title"]
  }

  class rsync_hdfs($files,
      $hadoop_security_authentcation = $hadoop::hadoop_security_authentication ) inherits hadoop {
    $src = $files[$title]

    if ($hadoop_security_authentication == "kerberos") {
      require hadoop::kinit
      Exec["HDFS kinit"] -> Exec["HDFS init $title"]
    }

    exec { "HDFS rsync $title":
      user => "hdfs",
      command => "/bin/bash -c 'hadoop fs -mkdir -p $title ; hadoop fs -put -f $src $title'",
      require => Service["hadoop-hdfs-namenode"],
    }
    Exec <| title == "activate nn1" |>  -> Exec["HDFS rsync $title"]
  }

  class namenode ( $nfs_server = "", $nfs_path = "" ) {
    include common_hdfs

    $http_port = $hadoop::common_hdfs::hadoop_namenode_http_port
    $port = $hadoop::common_hdfs::hadoop_namenode_port
    r8::export_variable { 'hadoop::namenode::http_port': }
    r8::export_variable { 'hadoop::namenode::port': }
    r8::export_variable { 'hadoop::namenode::hdfs_daemon_user': 
      content => 'hdfs'
    }

    if ($hadoop::common_hdfs::ha != 'disabled') {
      file { $hadoop::common_hdfs::sshfence_keydir:
        ensure  => directory,
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0700',
        require => Package["hadoop-hdfs"],
      }

      file { $hadoop::common_hdfs::sshfence_keypath:
        source  => "puppet:///files/$hadoop::common_hdfs::sshfence_privkey",
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0600',
        before  => Service["hadoop-hdfs-namenode"],
        require => File[$hadoop::common_hdfs::sshfence_keydir],
      }

      file { "$hadoop::common_hdfs::sshfence_keydir/authorized_keys":
        source  => "puppet:///files/$hadoop::common_hdfs::sshfence_pubkey",
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0600',
        before  => Service["hadoop-hdfs-namenode"],
        require => File[$hadoop::common_hdfs::sshfence_keydir],
      }

      if (! ('qjournal://' in $hadoop::common_hdfs::shared_edits_dir)) {
        file { $hadoop::common_hdfs::shared_edits_dir:
          ensure => directory,
        }

        if ($nfs_server) {
          if (!$nfs_path) {
            fail("No nfs share specified for shared edits dir")
          }

          require nfs::client

          mount { $hadoop::common_hdfs::shared_edits_dir:
            ensure  => "mounted",
            atboot  => true,
            device  => "${nfs_server}:${nfs_path}",
            fstype  => "nfs",
            options => "tcp,soft,timeo=10,intr,rsize=32768,wsize=32768",
            require => File[$hadoop::common::hdfs::shared_edits_dir],
            before  => Service["hadoop-hdfs-namenode"],
          }
        }
      }
    }

    package { "hadoop-hdfs-namenode":
      ensure => latest,
      require => Package["jdk"],
    }

    service { "hadoop-hdfs-namenode":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-hdfs-namenode"], File["/etc/hadoop/conf/core-site.xml"], File["/etc/hadoop/conf/hdfs-site.xml"], File["/etc/hadoop/conf/hadoop-env.sh"]],
      require => [Package["hadoop-hdfs-namenode"]],
    } 
    Kerberos::Host_keytab <| title == "hdfs" |> -> Exec <| tag == "namenode-format" |> -> Service["hadoop-hdfs-namenode"]

    if ($hadoop::common_hdfs::ha == "auto") {
      package { "hadoop-hdfs-zkfc":
        ensure => latest,
        require => Package["jdk"],
      }

      service { "hadoop-hdfs-zkfc":
        ensure => running,
        hasstatus => true,
        subscribe => [Package["hadoop-hdfs-zkfc"], File["/etc/hadoop/conf/core-site.xml"], File["/etc/hadoop/conf/hdfs-site.xml"], File["/etc/hadoop/conf/hadoop-env.sh"]],
        require => [Package["hadoop-hdfs-zkfc"]],
      } 
      Service <| title == "hadoop-hdfs-zkfc" |> -> Service <| title == "hadoop-hdfs-namenode" |>
    }

    $namenode_array = any2array($hadoop::common_hdfs::hadoop_namenode_host)
    $first_namenode = $namenode_array[0]
    if ($::fqdn == $first_namenode) {
      exec { "namenode format":
        user => "hdfs",
        command => "/bin/bash -c 'yes Y | hdfs namenode -format >> /var/lib/hadoop-hdfs/nn.format.log 2>&1'",
        creates => "${hadoop::common_hdfs::namenode_data_dirs[0]}/current/VERSION",
        require => [ Package["hadoop-hdfs-namenode"], File[$hadoop::common_hdfs::namenode_data_dirs], File["/etc/hadoop/conf/hdfs-site.xml"] ],
        tag     => "namenode-format",
      } 

      if ($hadoop::common_hdfs::ha != "disabled") {
        if ($hadoop::common_hdfs::ha == "auto") {
          exec { "namenode zk format":
            user => "hdfs",
            command => "/bin/bash -c 'yes N | hdfs zkfc -formatZK >> /var/lib/hadoop-hdfs/zk.format.log 2>&1 || :'",
            require => [ Package["hadoop-hdfs-zkfc"], File["/etc/hadoop/conf/hdfs-site.xml"] ],
            tag     => "namenode-format",
          }
          Service <| title == "zookeeper-server" |> -> Exec <| title == "namenode zk format" |>
          Exec <| title == "namenode zk format" |>  -> Service <| title == "hadoop-hdfs-zkfc" |>
        } else {
          exec { "activate nn1": 
            command => "/usr/bin/hdfs haadmin -transitionToActive nn1",
            user    => "hdfs",
            unless  => "/usr/bin/test $(/usr/bin/hdfs haadmin -getServiceState nn1) = active",
            require => Service["hadoop-hdfs-namenode"],
          }
        }
      }
    } elsif ($hadoop::common_hdfs::ha != "disabled") {
      hadoop::namedir_copy { $hadoop::common_hdfs::namenode_data_dirs:
        source       => $first_namenode,
        ssh_identity => $hadoop::common_hdfs::sshfence_keypath,
        require      => File[$hadoop::common_hdfs::sshfence_keypath],
      }
    }

    file {
      "/etc/default/hadoop-hdfs-namenode":
        content => template('hadoop/hadoop-hdfs'),
        require => [Package["hadoop-hdfs-namenode"]],
    }
    
    file { $hadoop::common_hdfs::namenode_data_dirs:
      ensure => directory,
      owner => hdfs,
      group => hdfs,
      mode => 700,
      require => [Package["hadoop-hdfs"]], 
    }
  }

  define namedir_copy ($source, $ssh_identity) {
    exec { "copy namedir $title from first namenode":
      command => "/usr/bin/rsync -avz -e '/usr/bin/ssh -oStrictHostKeyChecking=no -i $ssh_identity' '${source}:$title/' '$title/'",
      user    => "hdfs",
      tag     => "namenode-format",
      creates => "$title/current/VERSION",
    }
  }
      
  class secondarynamenode {
    include common_hdfs

    package { "hadoop-hdfs-secondarynamenode":
      ensure => latest,
      require => Package["jdk"],
    }

    file {
      "/etc/default/hadoop-hdfs-secondarynamenode":
        content => template('hadoop/hadoop-hdfs'),
        require => [Package["hadoop-hdfs-secondarynamenode"]],
    }

    service { "hadoop-hdfs-secondarynamenode":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-hdfs-secondarynamenode"], File["/etc/hadoop/conf/core-site.xml"], File["/etc/hadoop/conf/hdfs-site.xml"], File["/etc/hadoop/conf/hadoop-env.sh"]],
      require => [Package["hadoop-hdfs-secondarynamenode"]],
    }
    Kerberos::Host_keytab <| title == "hdfs" |> -> Service["hadoop-hdfs-secondarynamenode"]
  }

  class journalnode {
    include common_hdfs

    package { "hadoop-hdfs-journalnode":
      ensure => latest,
      require => Package["jdk"],
    }

    $journalnode_cluster_journal_dir = "${hadoop::common_hdfs::journalnode_edits_dir}/${hadoop::common_hdfs::nameservice_id}"

    service { "hadoop-hdfs-journalnode":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-hdfs-journalnode"], File["/etc/hadoop/conf/hadoop-env.sh"],
                    File["/etc/hadoop/conf/hdfs-site.xml"], File["/etc/hadoop/conf/core-site.xml"]],
      require => [ Package["hadoop-hdfs-journalnode"], File[$journalnode_cluster_journal_dir] ],
    }

    file { [ "${hadoop::common_hdfs::journalnode_edits_dir}", "$journalnode_cluster_journal_dir" ]:
      ensure => directory,
      owner => 'hdfs',
      group => 'hdfs',
      mode => 755,
      require => [Package["hadoop-hdfs"]],
    }
  }


  class resourcemanager {
    include common_yarn

    package { "hadoop-yarn-resourcemanager":
      ensure => latest,
      require => Package["jdk"],
    }

    service { "hadoop-yarn-resourcemanager":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-yarn-resourcemanager"], File["/etc/hadoop/conf/hadoop-env.sh"], 
                    File["/etc/hadoop/conf/yarn-site.xml"], File["/etc/hadoop/conf/core-site.xml"]],
      require => [ Package["hadoop-yarn-resourcemanager"] ],
    }
    Kerberos::Host_keytab <| tag == "mapreduce" |> -> Service["hadoop-yarn-resourcemanager"]
  }

  class proxyserver {
    include common_yarn

    package { "hadoop-yarn-proxyserver":
      ensure => latest,
      require => Package["jdk"],
    }

    service { "hadoop-yarn-proxyserver":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-yarn-proxyserver"], File["/etc/hadoop/conf/hadoop-env.sh"], 
                    File["/etc/hadoop/conf/yarn-site.xml"], File["/etc/hadoop/conf/core-site.xml"]],
      require => [ Package["hadoop-yarn-proxyserver"] ],
    }
    Kerberos::Host_keytab <| tag == "mapreduce" |> -> Service["hadoop-yarn-proxyserver"]
  }

  class historyserver {
    include common_mapred_app

    package { "hadoop-mapreduce-historyserver":
      ensure => latest,
      require => Package["jdk"],
    }

    service { "hadoop-mapreduce-historyserver":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-mapreduce-historyserver"], File["/etc/hadoop/conf/hadoop-env.sh"], 
                    File["/etc/hadoop/conf/yarn-site.xml"], File["/etc/hadoop/conf/core-site.xml"]],
      require => [Package["hadoop-mapreduce-historyserver"]],
    }
    Kerberos::Host_keytab <| tag == "mapreduce" |> -> Service["hadoop-mapreduce-historyserver"]
  }


  class nodemanager {
    include common_yarn
    include common_mapred

    package { "hadoop-yarn-nodemanager":
      ensure => latest,
      require => Package["jdk"],
    }
 
    service { "hadoop-yarn-nodemanager":
      ensure => running,
      hasstatus => true,
      subscribe => [Package["hadoop-yarn-nodemanager"], File["/etc/hadoop/conf/hadoop-env.sh"], 
                    File["/etc/hadoop/conf/yarn-site.xml"], File["/etc/hadoop/conf/core-site.xml"]],
      require => [ Package["hadoop-yarn-nodemanager"], File[$hadoop::common_yarn::yarn_data_dirs] ],
    }
    Kerberos::Host_keytab <| tag == "mapreduce" |> -> Service["hadoop-yarn-nodemanager"]

    file { $hadoop::common_yarn::yarn_data_dirs:
      ensure => directory,
      owner => yarn,
      group => yarn,
      mode => 755,
      require => [Package["hadoop-yarn"]],
    }
  }

  class mapred-app {
    include common_mapred_app

    file { $hadoop::common_mapred_app::mapred_data_dirs:
      ensure => directory,
      owner => yarn,
      group => yarn,
      mode => 755,
      require => [Package["hadoop-mapreduce"]],
    }
  }

  class client {
      include common_mapred_app

      $hadoop_client_packages = $operatingsystem ? {
        /(OracleLinux|CentOS|RedHat|Fedora)/  => [ "hadoop-doc", "hadoop-hdfs-fuse", "hadoop-client", "hadoop-libhdfs", "hadoop-debuginfo" ],
        /(SLES|OpenSuSE)/                     => [ "hadoop-doc", "hadoop-hdfs-fuse", "hadoop-client", "hadoop-libhdfs" ],
        /(Ubuntu|Debian)/                     => [ "hadoop-doc", "hadoop-hdfs-fuse", "hadoop-client", "libhdfs0-dev"   ],
        default                               => [ "hadoop-doc", "hadoop-hdfs-fuse", "hadoop-client" ],
      }

      package { $hadoop_client_packages:
        ensure => latest,
        require => [Package["jdk"], Package["hadoop"], Package["hadoop-hdfs"], Package["hadoop-mapreduce"]],  
      }
  }
}
