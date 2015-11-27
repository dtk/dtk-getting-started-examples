define maven::artifact(
  $id         = undef,
  $groupid    = undef,
  $artifactid = undef,
  $version    = undef,
  $repo_url   = undef,
  $repo_type  = undef,
  $packaging  = undef,
) {

  if $repo_url == undef {
    $repos = undef
  } else {
    if $repo_type == undef {
      $repos = [$repo_url]
    } else {
      $repos = ["${repo_url}/${repo_type}"]
    }   
  }

  maven { $name:
    id         => $id,
    groupid    => $groupid,
    artifactid => $artifactid,
    version    => $version,
    repos      => $repos,
    packaging  => $packaging,
  }
}
