define spark::install::package::component()
{
  $spark_package = $name

  # included as oppose to specfic class in case master and worker on same node
  include spark::install::package
  unless $spark_package == 'spark-core' {
    package { $spark_package:
      ensure  => $spark::install::version,
      require => Class['spark::install::package']
    }
  }
}

class spark::install::package()
{
  package { 'spark-core':
    ensure  => $spark::install::version
  }
}