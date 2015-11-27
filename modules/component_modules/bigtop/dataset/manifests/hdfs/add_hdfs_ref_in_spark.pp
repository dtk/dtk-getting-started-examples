define dataset::hdfs::add_hdfs_ref_in_spark(
 $target_directory
)
{

  #removing charachters that cannot be user in bash env var
  $bash_var = inline_template("<%= @name.gsub(/-/,'_') %>")
  $value = "hdfs://\${HDFS_NAMENODE_HOST}:${hdfs_port}${target_directory}/*"

  # TODO: hard coded location of spark conf dir
  # hard coded hdfs port; this should make call to spark component that does these operations
  $hdfs_port = '8020'
  $spark_conf_dir = '/etc/spark/conf'

  $spark_env_file = "${spark_conf_dir}/spark-env.sh"

  exec {"sed '/^export {$bash_var}/d' ${spark_env_file}":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -f ${spark_env_file}"
  } ->

  exec { "echo 'export ${bash_var}=${value}' >> ${spark_env_file}":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -f ${spark_env_file}"
  }
}
