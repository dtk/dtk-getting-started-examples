class ignite::configure(
  $node_addresses,
) inherits ignite::params
{

  file { $ignite_conf_dir: 
    ensure  => 'directory',
    owner   => $ignite_daemon_user,
    group   => $ignite_daemon_user,
  }

  file { "${ignite_conf_dir}/${ignite_conf_file}": 
    ensure  => 'present',
    content => template("ignite/conf/${ignite_conf_file}.erb"),
    owner   => $ignite_daemon_user,
    group   => $ignite_daemon_user,
    require => File[$ignite_conf_dir]
  }

}

