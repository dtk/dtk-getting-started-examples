class ignite::install::cache_objects::build() inherits ignite::install::cache_objects
{

  ignite::util::mkdir_p{ $cache_object_projects_dir: }

  file { "${cache_object_projects_dir}/pom.xml":
    ensure  => 'present',
    content => template("ignite/build/${cache_object_artifact_id}/pom.xml.erb"),
    owner   => $ignite_daemon_user,
    group   => $ignite_daemon_user,
    require => Ignite::Util::Mkdir_p[$cache_object_projects_dir]
  }

  ignite::util::mkdir_p{ $cache_object_source_code_dir: }

  #### create java source files ####

  File<|tag == 'ignite_java_source_file'|> {
    owner   => $ignite_daemon_user,
    group   => $ignite_daemon_user,
    require => Ignite::Util::Mkdir_p[$cache_object_source_code_dir],
    before  => Ignite::Maven::Package[$cache_object_projects_dir],
  }

  # TODO: stub
  $has_spark_driver = false
  if $has_spark_driver {
    $group_id = $cache_object_group_id
    $create_shared_rdd_java_file = 'CreateSharedRdd.java' 
    file { "${cache_object_source_code_dir}/${create_shared_rdd_java_file}":
      ensure  => 'present',
      content => template("ignite/build/${cache_object_artifact_id}/${create_shared_rdd_java_file}.erb"),
      tag     => 'ignite_java_source_file'
    }
  }

  create_resources('ignite::install::cache_objects::build::add_cache_object_source_file', $cache_object_hash)

  #### end: create java source files ####

  ignite::maven::package { $cache_object_projects_dir: 
    require => File["${cache_object_projects_dir}/pom.xml"]
  }

  file { "${ignite_lib_dir}/${cache_object_local_jar_name}":
    ensure  => 'link',
    target  => $cache_object_target_jar,
    require => Ignite::Maven::Package[$cache_object_projects_dir]
  }
}

define ignite::install::cache_objects::build::add_cache_object_source_file(
  $cache_object = {}
)
{

  $java_file_name = inline_template("<%= @name.capitalize %>.java")

  $cache_object_projects_dir    = $ignite::install::cache_objects::build::cache_object_projects_dir
  $cache_object_source_code_dir = $ignite::install::cache_objects::build::cache_object_source_code_dir
  $cache_object_artifact_id     = $ignite::install::cache_objects::build::cache_object_artifact_id
  $cache_object_group_id        = $ignite::install::cache_objects::build::cache_object_group_id

  file { "${cache_object_source_code_dir}/${java_file_name}":
    ensure  => 'present',
    content => template("ignite/build/${cache_object_artifact_id}/Template.java.erb"),
    tag     => 'ignite_java_source_file'
  }
}

