# TODO: wil deprecate
define hadoop::hdfs_directory(
   $mode,
   $owner = undef,
   #TODO: not treating yet   $hadoop_security_authentication = 'simple'
)
{
  $path = $name
  include hadoop::params
  $hdfs_superuser = $hadoop::params::hdfs_superuser
  
  if $owner == undef {
    $owner_final = $hdfs_superuser
  } else {
    $owner_final = $owner
  }

  exec { "hdfs_directory ${name}":
    user    => $hdfs_superuser, 
    command => "/bin/bash -c 'hadoop fs -mkdir -p $path && hadoop fs -chmod $mode $path && hadoop fs -chown $owner $path'",
    unless  => "/bin/bash -c 'hadoop fs -ls $path'"
  }
}
