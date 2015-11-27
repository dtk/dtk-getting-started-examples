class dtk_util::apt_get_update()
{
  case $::operatingsystem {
    /^(Debian|Ubuntu)$/:{
      exec { 'dtk_util::apt_get_update':
        command => 'apt-get update && touch /tmp/dtk_util-apt-get-update',
        creates => '/tmp/dtk_util-apt-get-update',
        path    => ['/usr/bin']
      }
      Exec['dtk_util::apt_get_update'] -> Package<||>
    }
  }
}
