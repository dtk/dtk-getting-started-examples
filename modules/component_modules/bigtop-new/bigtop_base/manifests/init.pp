class bigtop_base(
  # globals: set same way on all nodes
  # set by hiera
  $set_hostname = false,
  # TODO: cleanup so set_hostname and jdk_devel_package_name treated same way 
  $jdk_devel_package_name = hiera('bigtop::jdk_devel_package_name',''),

  # set node by node
  $with_jdk = false,
  $with_maven = false
) 
{
#  $default_yumrepo = "http://ci.bigtop.apache.org:8080/view/Releases/job/Bigtop-1.0.0-rpm/BUILD_ENVIRONMENTS=centos-6%2clabel=docker-slave-06/lastSuccessfulBuild/artifact/output/"
  $default_yumrepo = "http://bigtop-repos.s3.amazonaws.com/releases/1.0.0/centos/6/x86_64"

  $jdk_package_name = hiera("bigtop::jdk_package_name", "jdk")

  stage {"pre": before => Stage["main"]}

  case $operatingsystem {
      /(OracleLinux|Amazon|CentOS|Fedora|RedHat)/: {
         yumrepo { "Bigtop":
            baseurl => hiera("hiera::bigtop_yumrepo_uri", $default_yumrepo),
            descr => "Bigtop packages",
            enabled => 1,
            gpgcheck => 0,
         }
      }
      default: {
        notify{"WARNING: running on a non-yum platform -- make sure Bigtop repo is setup": }
      }
  }

  package { $jdk_package_name:
    ensure => "installed",
    alias => "jdk",
  }


  if $with_jdk or $with_maven {
    unless $jdk_devel_package_name == '' {
      package { $jdk_devel_package_name:
        ensure => 'installed'
      }
    }
  }
  
  if $with_maven {
    contain maven
  }

  $config_state_dir = bigtop_global('config_state_dir')
  exec { "mkdir -p ${config_state_dir}":
    creates => $config_state_dir,
    path    => ['/bin']
  }

  service { 'iptables':
    ensure => 'stopped'
  }

  if $set_hostname { 
    # TODO: enable this
    # curerntly not treated until each host (worker, included) gets the fqdn for each, which we put in /etc/hosts
    fail("Currently set_hostname is not treated")

    $cleaned_host_name = inline_template("<%= (@dtk_assembly_node||'').gsub(/:/,'-') %>")
     class { 'host::hostname':
       name => $cleaned_host_name
     }
  }
}
