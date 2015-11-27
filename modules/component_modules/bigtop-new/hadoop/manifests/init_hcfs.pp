class hadoop::init_hcfs(
  $root_user   = $hadoop::params::hdfs_superuser,
  $daemon_dirs = [],
  $users       = []
) inherits hadoop::params 
{

  $init_hcfs_script = "${hadoop_script_dir}/init-hcfs2.sh"
  $init_hcfs_groovy = "${bigtop_utils_dir}/init-hcfs.groovy"

  include bigtop_toolchain::groovy
  $groovy_bin_dir = "${bigtop_toolchain::groovy::groovy_dir}/bin"

  file { $init_hcfs_groovy:
    source => 'puppet:///modules/hadoop/bigtop-utils/init-hcfs.groovy',
    mode   => '0755'
  }

  file { "${hadoop_script_dir}/init-hcfs.json": 
    content => template('hadoop/init-hcfs.json')
  }

  file { $init_hcfs_script:
    content => template('hadoop/init-hcfs.sh'),
    mode    => '0755'
  }

  exec { "${init_hcfs_script} &> /tmp/init_hcfs.log":
    logoutput => true,
    require   => [Class[bigtop_toolchain::groovy],
                  File[$init_hcfs_groovy, $init_hcfs_script, "${hadoop_script_dir}/init-hcfs.json"]],
    path      => ['/bin','/usr/bin']
  }
}