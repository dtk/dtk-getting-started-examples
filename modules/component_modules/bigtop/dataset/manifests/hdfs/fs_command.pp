define dataset::hdfs::fs_command(
  $unless      = undef,
  $creates     = undef,
  $refreshonly = undef,
  $path        = ['/bin', '/usr/bin']
)
{
  $command = $name

  include dataset::hdfs::params
  $hdfs_superuser = $dataset::hdfs::params::hdfs_superuser

  if $creates != undef {
    $real_unless = "su ${hdfs_superuser} -c 'hadoop fs -ls ${creates}'  > /dev/null"  
  } elsif $unless != undef {
    $real_unless = $unless
  } else {
    $real_unless = undef
  }

  exec { "su ${hdfs_superuser} -c 'hadoop fs -${command}'":
    unless      => $real_unless,
    refreshonly => $refreshonly,
    path        => $path
  }
}
