class ignite::install_and_configure(
  $globals          = {},
  $has_spark_driver = false
) inherits ignite::params
{

  if $globals['node_addresses'] == undef {
    $node_addresses = [$::ipaddress]
  } else {
    $node_addresses = $globals['node_addresses']
  }

  # could be null
  $local_maven_repo_url = $globals['local_maven_repo_url']

  class { 'ignite::install': 
    local_maven_repo_url => $local_maven_repo_url,
    has_spark_driver     => $has_spark_driver
  }

  class { 'ignite::configure':
    node_addresses => $node_addresses,
    require        => Class['ignite::install']
  }
}
