define spark::install::component()
{
  $type = $name

  $daemon_package = $type ? {
    'master'           => 'spark-master',
    'worker'           => 'spark-worker',
    'history-server'   => 'spark-history-server',
    'core'             => 'spark-core',
    default  => undef
  }

  if $daemon_package == undef {
    fail("Invalid type '${type}'")
  }

  include spark::install

  case $spark::install::mode {
    'tar'    : { spark::install::tar::component { $daemon_package:} }
    'package': { spark::install::package::component { $daemon_package:} }
    default:   { fail("Invalid mode '${spark::install::mode}'") }          
  }
}

# TODO: this is probably unneeded
# just used to have hiera pass in attributes
class spark::install(
  $mode    = bigtop_global('spark_install_mode', 'package'), # can be 'package' || 'tar'
  $version = bigtop_global('spark_version')
)
{
}


