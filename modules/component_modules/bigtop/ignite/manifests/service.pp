class ignite::service(
  $ensure = 'running'
) inherits ignite::params
{
  service { $ignite_service:
    ensure => $ensure
  }
}
