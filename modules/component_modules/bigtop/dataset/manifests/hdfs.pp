define dataset::hdfs(
  $target_directory,
  $owner             = undef,
  $source_type       = undef,
  $source,
  $dv__load_command_line = "dataset::hdfs[${name}]::load_command_line",
  $dv__hdfs_superuser    = "dataset::hdfs[${name}]::hdfs_superuser"
)
{

  include dataset::hdfs::params
  r8::export_variable { $dv__hdfs_superuser:
    content => $dataset::hdfs::params::hdfs_superuser
  }

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

  case $final_source_type {
    'http': { 
      dataset::hdfs::load_from_http { $name:
        target_directory      => $target_directory,
        source                => $source,
        owner                 => $final_owner,
        dv__load_command_line => $dv__load_command_line,
      }
    }
    undef: { fail("Either 'source_type' or 'source[type]' must be given") }
    default: { fail("Loading from source of type '${final_source_type} not supported") }
  }

  $spark_version = bigtop_global('spark_version')
  if $spark_version != undef {
    dataset::hdfs::add_hdfs_ref_in_spark { $name:
      target_directory => $target_directory
    }
  }

}

