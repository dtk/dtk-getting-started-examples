class spark::params()
{

  $spark_version           = bigtop_global('spark_version')
  $hadoop_version          = bigtop_global('hadoop_version')
  $hadoop_semantic_version = bigtop_global('hadoop_semantic_version')
  $spark_daemon_user       = bigtop_global('spark_daemon_user', 'spark')

  $spark_base_dir    = bigtop_global('services_base_dir')
  $spark_dir         = "${spark_base_dir}/spark"
  $spark_conf_dir    = '/etc/spark/conf'
  $spark_initd_base  = '/etc/rc.d/init.d'

  $spark_var_log_dir = '/var/log/spark'
  $spark_var_run_dir = '/var/run/spark'

  $spark_work_dir    = "${spark_var_run_dir}/work"
}