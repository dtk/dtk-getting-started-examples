class hadoop::params()
{
  # users
  $hdfs_superuser = 'hdfs'

  # directories
  $base_dir          = '/usr/lib' 

  $hadoop_dir        = "${base_dir}/hadoop"
  $hadoop_lib_dir    = "${hadoop_dir}/lib"
  $hadoop_script_dir = "${hadoop_dir}/libexec"

  $hdfs_dir          = "${base_dir}/hadoop-hdfs"
  $hdfs_lib_dir      = "${hdfs_dir}/lib"

  $hadoop_conf_dir   = '/etc/hadoop/conf'

  # TODO: might move thi smore globally
  $bigtop_utils_dir = "${base_dir}/bigtop-utils"
}