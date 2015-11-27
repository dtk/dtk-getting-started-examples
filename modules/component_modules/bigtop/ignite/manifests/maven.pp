define ignite::maven::package()
{
  $projects_dir = $name

  exec { 'mvn package': 
    cwd        => $projects_dir,
    path       => ['/usr/local/bin', '/usr/bin', '/bin'],
    logoutput  => 'on_failure'
  }
}
