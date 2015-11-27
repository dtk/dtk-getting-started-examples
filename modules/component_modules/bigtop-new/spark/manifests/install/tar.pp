define spark::install::tar::component()
{
  $spark_package = $name

  include spark::params

  $spark_daemon_user = $spark::params::spark_daemon_user
  $spark_var_log_dir = $spark::params::spark_var_log_dir
  $spark_var_run_dir = $spark::params::spark_var_run_dir
  $spark_conf_dir    = $spark::params::spark_conf_dir


  include spark::install::tar
   
  unless $spark_package == 'spark-core' {
    $spark_initd_base = $spark::params::spark_initd_base
    file { "${spark_initd_base}/${spark_package}":
      ensure  => 'present',
      content => template("spark/init.d/${spark_package}.erb"),
      mode    => '0755'
    }
  }
}

class spark::install::tar(
  $options = {}
) inherits spark::params
{

  # use hadoop-2.6 if version is 2.6 or later
  $hadoop_v = inline_template("<%= @hadoop_version.to_f > 2.6 ? 2.6 : @hadoop_version %>")	
  $binary_url = "http://apache.mirrors.ionfish.org/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_v}.tgz"


  $version = bigtop_global('spark_version')

  $spark_build_dir = "${spark_base_dir}/spark-${version}-bin-hadoop${hadoop_v}"

  unless $spark_daemon_user == 'root' { 
    user { $spark_daemon_user: 
      ensure     => 'present',
      managehome => true,
      before     => File[$spark_var_run_dir, $spark_var_log_dir]
    }
  }

  file { [$spark_var_run_dir, $spark_var_log_dir] :  
    ensure  => 'directory',
    owner   => $spark_daemon_user,
    group   => $spark_daemon_user
  }

  file { $spark_work_dir:
    ensure  => 'directory',
    owner   => $spark_daemon_user,
    group   => $spark_daemon_user,
    require => File[$spark_var_run_dir]
  }

  dtk_util::tar_install{ $spark_build_dir:
    source => $binary_url,
    owner  => $spark_daemon_user,
    group  => $spark_daemon_user,
    # TODO: see if mode to 077 is needed; put in so that derby db can be created when spark-shell run
    mode   => '0777'
  }

  file { $spark_dir:
    ensure  => 'link',
    target  => $spark_build_dir,
    require => Dtk_util::Tar_install[$spark_build_dir]
  }

  file { "${spark_dir}/work":
    ensure  => 'link',
    target  => $spark_work_dir,
    require => [Dtk_util::Tar_install[$spark_build_dir], File[$spark_work_dir]]
  }

  exec { "create ${spark_conf_dir}":
    command => "mkdir -p ${spark_conf_dir}",
    creates => $spark_conf_dir,
    path    => ['/bin','/usr/bin']
  }

}
