class bigtop_multiservice::hiera(
  $globals = {}
) inherits bigtop_multiservice::params
{

  # versions; undef means not including this service
  $java_version = $globals['java_version']
  $java_semantic_version = "${java_version}.0"

  $hadoop_version = $globals['hadoop_version']
  $hadoop_semantic_version = "${hadoop_version}.0"	
  $spark_version = $globals['spark_version']
  $ignite_version = $globals['ignite_version']

  # daemon users
  if $globals['hdfs_daemon_user'] != undef {
    $hdfs_daemon_user = $globals['hdfs_daemon_user']
  } elsif $hadoop_version != undef {
    $hdfs_daemon_user = $default_hdfs_daemon_user 
  } else { $hdfs_daemon_user = undef }

  # need to align spark_daemon_user and ignite_daemon_user
  # TODO: may be able to just have same group
  $spark_user = $globals['spark_daemon_user']
  $ignite_user = $globals['ignite_daemon_user']

  # if this is true then both ignite are configured	
  if $spark_version != undef and $ignite_version != undef {
    $dflt = $default_common_ignite_spark_daemon_user
    $common_user = inline_template("<%= lambda{|u| u.empty? ? @dflt : (u.size == 1 ? u[0] : (u[0] == u[1] ? u[0] : 'FAIL'))}.call([@spark_user,@ignite_user].compact) %>")
    if $common_user == 'FAIL' {
      fail("Spark daemon user '${spark_user}' and Ignite daemon user '${ignite_user}' must be the same") 
    } else {
      $spark_daemon_user = $common_user
      $ignite_daemon_user = $common_user
    }
  } else {
    # if reach here then dont have both ignite and spark

    if $spark_user != undef {
      $spark_daemon_user = $spark_user
    } elsif $spark_version != undef {
       $spark_daemon_user = $default_spark_daemon_user 
    } else { $spark_daemon_user = undef }

    if $ignite_user != undef { 
      $ignite_daemon_user = $ignite_user 
    } elsif $ignite_version != undef { 
      $ignite_daemon_user = $default_ignite_daemon_user 
    } else { $ignite_daemon_user = undef }
  }

  file { '/etc/puppet/hiera.yaml':
    source => 'puppet:///modules/bigtop_multiservice/hiera.yaml'
  }

  file { '/etc/puppet/hieradata/':
    source  => 'puppet:///modules/bigtop_multiservice/hieradata',
    recurse => true
  }

  file { '/etc/puppet/hieradata/site.yaml':
    content => template('bigtop_multiservice/hieradata/site.yaml'),
    require => File['/etc/puppet/hieradata/']
  }
}
