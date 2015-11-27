define dataset::hdfs::load_from_http(
  $target_directory,
  $owner,
  $source,
  $dv__load_command_line
)
{

  $source_file_directory_url = $source['file_directory_url']
  $source_files = $source['files']

  # TODO: now only supporting source when has keys :file_directory_url and :files
  unless $source_file_directory_url != undef and $source_files != undef {
    fail("Only supporting http source when has keys 'file_directory_url' and 'files'")
  }

  include dataset::hdfs::load_from_http::common
  $config_state_prefix = $dataset::hdfs::load_from_http::common::config_state_prefix
  $bash_file            = $dataset::hdfs::load_from_http::common::bash_file
  $source_files_array   = dataset_process_file_wild_cards($source_files)
  $source_files_path    = "${config_state_prefix}--${name}"

  file { $source_files_path:
    content => inline_template("<%= @source_files_array.inject('') { |s, f| \"#{s}\n#{f}\" } + \"\n\" %>")
  }

  r8::export_variable { $dv__load_command_line:
    content => "${bash_file} ${name} ${owner} '${source_file_directory_url}' ${target_directory}"
  }

}

class dataset::hdfs::load_from_http::common() inherits dataset::hdfs::params
{

  $config_state_dir    = bigtop_global('config_state_dir')
  $prefix              = "${config_state_dir}/load_http_into_hdfs" 
  $config_state_prefix = "${prefix}--configured"
  $actual_state_prefix = "${prefix}--actual"

  $bash_file = "/usr/share/dtk/load_http_into_hdfs"
  file { $bash_file:
    content => template("dataset/bash/load_http_into_hdfs.sh.erb"),
    mode    => '0755'
  }
}
