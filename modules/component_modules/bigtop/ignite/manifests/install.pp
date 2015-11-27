class ignite::install(
  # comes from hiera 
  $version = undef,
  $mode    = 'tar',

  ## TODO: should come from hiera
  $spark_version = '1.5.1',
  
  $has_spark_driver = false,
  $local_maven_repo_url = undef
) inherits ignite::params
{

  if $version == undef {
    fail("The attribute ignite::install::version is not given")
  }

  $ignite_build_dir = "${ignite_base_dir}/apache-ignite-fabric-${version}-bin"

  unless $ignite_daemon_user == 'root' {
    user { $ignite_daemon_user: 
      ensure     => 'present',
      managehome => true,
      before     => File[$ignite_var_run_dir, $ignite_var_log_dir]
    }
  }

  file { [$ignite_var_run_dir, $ignite_var_log_dir] :  
    ensure  => 'directory',
    owner   => $ignite_daemon_user,
    group   => $ignite_daemon_user,
  }

  if $mode == 'tar' and $version == '1.5.0' {
    $real_mode ='local_repo'
  } else {
    $real_mode = $mode
  }

  case $real_mode {
    'tar': { 
      class { 'ignite::install::tar':
        before => File[$ignite_dir]
      } 
    }
    'local_repo': { 
      class { 'ignite::install::local_repo':
        before => File[$ignite_dir]
      } 
    }
    default: { fail("Invalid mode '${real_mode}'") }          
  }

  file { $ignite_dir:
    ensure  => 'link',
    target  => $ignite_build_dir
  }

  class { 'ignite::install::cache_objects':
    require => File[$ignite_dir]
  }

  file { "${ignite_initd_base}/${ignite_service}":
    ensure  => 'present',
    content => template("ignite/init.d/${ignite_service}.erb"),
    mode    => '0755'
  }
}

