define ignite::maven_install_from_local_repo(
  $maven_id,
  $repos
)
{

  $target_path = $name

  # TODO: rather than using maven_settings which is wide scope so if can just put these more locally
  include ignite::maven_install_from_local_repo::maven_settings

  maven { $target_path:
    id      =>  $maven_id,
    repos   => $repos,
    require => Class['ignite::maven_install_from_local_repo::maven_settings']
  }
}

class ignite::maven_install_from_local_repo::maven_settings()
{
  # TODO: fix it that use this plus puppet tools maven
  include maven

  # TODO: username and pw are hardwired for now
  $servers = [
    { id       => 'local-maven-repo',
      username => 'deployment',
      password => 'deployment123'
    }
  ]	

  maven::settings { 'ignite-extra-jars':
    servers => $servers,
    require => Class['maven']
  }
}


