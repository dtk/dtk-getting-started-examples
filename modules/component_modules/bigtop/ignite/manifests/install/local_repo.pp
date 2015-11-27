class ignite::install::local_repo() inherits ignite::install
{
  if $local_maven_repo_url == undef {
    fail("The attribute '$local_maven_repo_url' not given for ignite::install::local_repo'")	
  }

  $maven_binary_zip_id = "org.apache.ignite:local-ignite:${version}:zip"

  ignite::maven_install_from_local_repo { "${ignite_build_dir}.zip":
    maven_id => $maven_binary_zip_id,
    repos    => [$local_maven_repo_url]
  }

  # TODO: may not be robust
  $zip_dirname = "apache-ignite-fabric-${version}-SNAPSHOT-bin" 
  exec { "unzip ${ignite_build_dir}.zip": 
    cwd     => $ignite_base_dir,
    command => "unzip ${ignite_build_dir}.zip && mv ${zip_dirname} $ignite_build_dir",
    path    => ['/bin', '/usr/bin'],
    creates => $ignite_build_dir,
    require => Ignite::Maven_install_from_local_repo["${ignite_build_dir}.zip"]
  }

}

