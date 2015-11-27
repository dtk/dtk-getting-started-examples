class hadoop::hdfs_directories(
  # each element is a hash with keys
  #  path
  #  owner
  #  mode (optional)
  #  group (optional)
  $daemon_dirs = [],
  $root_user   = $hadoop::params::hdfs_superuser,
) inherits hadoop::params
{

  class { 'hadoop::init_hcfs': 
    daemon_dirs => $daemon_dirs,
    root_user   => $root_user,
  }
}
    