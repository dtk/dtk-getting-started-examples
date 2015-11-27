define gitarchive(
  $year,
  $month,
  $day,
  $hours = '{0..23}',
  $owner,
)
{
  $hdfs_files_directory = "/user/local/${owner}/data/gitarchive/${name}"
  $dv_prefix = "gitarchive[${name}]"
 
  r8::export_variable { "${dv_prefix}::hdfs_files_directory":
    content => $hdfs_files_directory
  }

  $source = {
    type               => 'http',
    file_directory_url => 'http://data.githubarchive.org',
    files              => "${year}-${month}-${day}-${hours}.json.gz"
  }

  dataset::hdfs { $name:
    target_directory      => $hdfs_files_directory,
    owner                 => $owner,
    source                => $source,
    dv__load_command_line => "${dv_prefix}::load_command_line",
    dv__hdfs_superuser    => "${dv_prefix}::hdfs_superuser"
  }
}



