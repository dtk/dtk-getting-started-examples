define dataset::hdfs::load(
  $target_directory,
  $owner             = undef,
  $source_type       = undef,
  $source
)
{

  include dataset::hdfs::params
  if $owner == undef {
    $final_owner = $dataset::hdfs::params::hdfs_superuser
  } else {
    $final_owner = $owner
  }

  if $source_type != undef {
    $final_source_type = $source_type
  } else {
    $final_source_type = $source['type']    
  }

  dataset::hdfs::mkdir_p { $target_directory:
    owner => $final_owner
  }

  case $final_source_type {
    'http': { 
      dataset::hdfs::load::from_http { $name:
        target_directory => $target_directory,
        source           => $source,
        owner            => $final_owner,
        require          => Dataset::Hdfs::Mkdir_p[$target_directory]
      }
    }
    undef: { fail("Either 'source_type' or 'source[type]' must be given") }
    default: { fail("Loading from source of type '${final_source_type} not supported") }
  }

  $spark_version = bigtop_global('spark_version')
  if $spark_version != undef {
    dataset::hdfs::load::add_spark_env_var { $name:
      target_directory => $target_directory
    }
  }

}

define dataset::hdfs::load::add_spark_env_var(
 $target_directory
)
{
  # TODO: hard coded location of spark conf dir
  # hard coded hdfs port
  # TODO: this should make call to spark component that does these operations
  $hdfs_port = '8020'
  $spark_conf_dir = '/etc/spark/conf'
  $spark_env_file = "${spark_conf_dir}/spark-env.sh"
  $export_var = "export ${name}="
  $value = "hdfs://\${HDFS_NAMENODE_HOST}:${hdfs_port}${target_directory}/*"

  exec {"sed '/${export_var}/d' ${spark_env_file}":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -f ${spark_env_file}"
  } ->

  exec {"echo '${export_var}${value}' >> ${spark_env_file}":
    path   => ['/bin', '/usr/bin'],
    onlyif => "test -f ${spark_env_file}"
  }
}