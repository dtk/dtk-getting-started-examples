class ignite::params(
  # This can be overwritten by Hiera
  $ignite_daemon_user = 'ignite'
) 
{
  $ignite_service     = 'ignite'
  $ignite_base_dir    = '/usr/lib'
  $ignite_dir         = "${ignite_base_dir}/ignite"
  $ignite_lib_dir     = "${ignite_dir}/libs"
  $ignite_conf_dir    = "${ignite_dir}/config"
  $ignite_conf_file   = 'config.xml'
  $ignite_initd_base  = '/etc/rc.d/init.d'

  $ignite_var_log_dir = '/var/log/ignite'
  $ignite_var_run_dir = '/var/run/ignite'

  $daemon_port_range = '47500..47509'

  $external_repo_url = 'www.gridgainsystems.com/nexus/content/repositories/external'



  $cache_object_artifact_id = 'ignite-cache-objects'  
  $cache_object_local_jar_name = "${cache_object_artifact_id}.jar"  
  $cache_object_group_id = 'io.dtk'
  $cache_object_version = '1.0.0'

  $cache_object_projects_dir = "${ignite_dir}/projects/${cache_object_artifact_id}"
  $cache_object_source_code_dir = inline_template("<%= @cache_object_projects_dir %>/src/main/java/<%= @cache_object_group_id.gsub('.','/') %>")
  $cache_object_target_jar = "${cache_object_projects_dir}/target/${cache_object_artifact_id}-${cache_object_version}.jar"

  include ignite::params::cache_object_meta_info
  $cache_object_hash = ignite_convert_raw_input_cache_objects($ignite::params::cache_object_meta_info::hash, $cache_object_group_id)
  $cache_object_array = ignite_hash_values($cache_object_hash)

}