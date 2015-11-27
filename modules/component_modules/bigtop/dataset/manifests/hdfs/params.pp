class dataset::hdfs::params()
{
  include hadoop::params
  $hdfs_superuser = $hadoop::params::hdfs_superuser
}