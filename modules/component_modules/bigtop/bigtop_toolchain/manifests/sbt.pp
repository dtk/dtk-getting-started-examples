class bigtop_toolchain::sbt() {
  case $::operatingsystem {
    /Ubuntu|Debian/: {
      class { 'bigtop_toolchain::sbt::debian' :
        before => Package['sbt']
      }
    }
    /OracleLinux|Amazon|CentOS|Fedora|RedHat/: {
      class { 'bigtop_toolchain::sbt::redhat': 
        before => Package['sbt']
      }
    }
    default: {
      fail("OS ${::operatingsystem} not supported")
    }
  }
  package { 'sbt': }
  
}

class bigtop_toolchain::sbt::debian()     
{
  exec { 'echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list':
    path    => ['/bin','/usr/bin'],
    creates => '/etc/apt/sources.list.d/sbt.list' 
  }
}

class bigtop_toolchain::sbt::redhat()
{
  exec { 'curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo':
    path    => ['/usr/bin'],
    creates => '/etc/yum.repos.d/bintray-sbt-rpm.repo'
  }
}


