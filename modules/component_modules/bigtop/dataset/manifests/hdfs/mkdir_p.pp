define dataset::hdfs::mkdir_p(
  $owner,
  $group = undef,
  $mode  = undef)
{
  $target_dir = $name

  if $group == undef {
    $chown = $owner
  } else {
    $chown = "${owner}:${$group}"
  }

  dataset::hdfs::fs_command { "mkdir -p ${target_dir}": 
    creates => $target_dir
  }

  dataset::hdfs::fs_command { "chown ${chown} $target_dir": 
    refreshonly => true, 
    subscribe   => Dataset::Hdfs::Fs_command["mkdir -p ${target_dir}"]
  }

  if $mode != undef {
    dataset::hdfs::fs_command { "chmod ${mode} $target_dir": 
      refreshonly => true, 
      subscribe => Dataset::Hdfs::Fs_command["mkdir -p ${target_dir}"]
    }
  }
}
