define dtk_util::tar_install(
  $source,
  $owner            = 'root',
  $group            = 'root',
  $mode             = undef,
  $source_extension = 'tgz' # can also be 'zip'
)
{
  $destination_dir = $name
  $compressed_file = "${destination_dir}.${source_extension}"
  $base_dir = inline_template("<%= (@destination_dir.match('(^.+)/[^/]+$')||[])[1] %>")
  if $base_dir == undef {
    fail("cannot determine base directory from '${destination_dir}'")
  }

  $uncompress_command = $source_extension ? {
    'tgz'    => 'tar xf',
    'zip'    => 'unzip',
    default  => undef
  }

  if $uncompress_command == undef {
    fail("Invalid source_extension '${source_extension}'")
  }

  wget::fetch { "fetch ${compressed_file}":
    source      => $source,
    destination => $compressed_file,
    require     => Class['wget']
  } ->

  exec { "uncompress ${compressed_file}":
    command  => "${uncompress_command} ${compressed_file}",
    cwd      => $base_dir,
    creates  => $destination_dir,
    path     => ['/bin','/usr/bin']
  } ->

  file { $destination_dir:
    ensure => 'directory',
    owner  => $owner,
    group  => $group,
    mode   => $mode
  }

}