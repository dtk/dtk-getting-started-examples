class ignite::install::tar(
  $options = {}
) inherits ignite::install
{
  $binary_url = $options[binary_url]
  if $binary_url == undef {
    fail("The attribute ignite::install::tar::options[binary_url] not given")    
  }

  dtk_util::tar_install{ $ignite_build_dir:
    source           => $binary_url,
    source_extension => 'zip',
    owner            => $ignite_daemon_user,
    group            => $ignite_daemon_user
  }

}

