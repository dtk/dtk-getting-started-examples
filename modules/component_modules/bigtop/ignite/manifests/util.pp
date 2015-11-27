define ignite::util::mkdir_p()
{
  $dir = $name

  include ignite::params
  $user = "${ignite::params::ignite_daemon_user}"

  exec { "mkdir -p ${dir} && chown ${user}:${user} ${dir}":
    creates => $dir,
    path    => ['/bin']
  }
}
