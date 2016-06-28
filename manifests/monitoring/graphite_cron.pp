# Instat s
# are sent to graphite
define mysql::monitoring::graphite_cron(
  $mysql_host,
  $ensure     = present,
  $mysql_user = undef,
  $mysql_pass = undef,
  $mysql_port = undef,
  $graphite_host = undef,
  $graphite_port = undef,
  $graphite_key = undef,
  $monitoring_interval = 5, # minutes
) {

  include ::mysql::monitoring

  $param_host = [ "--host ${mysql_host}" ]

  if($mysql_user != undef) {
    $param_user = "--user ${mysql_user}"
  } else {
    $param_user = ''
  }

  if($mysql_pass != undef) {
    $param_pass = "--pass ${mysql_pass}"
  } else {
    $param_pass = ''
  }

  if($mysql_port != undef) {
    $param_port = "--port ${mysql_port}"
  } else {
    $param_port = ''
  }

  if($graphite_host != undef) {
    $param_graphite_host = "--graphite-host ${graphite_host}"
  } else {
    $param_graphite_host = ''
  }

  if($graphite_port != undef) {
    $param_graphite_port = "--graphite-port ${graphite_port}"
  } else {
    $param_graphite_port = ''
  }

  if($graphite_key != undef) {
    $param_graphite_key = "--graphite-key ${graphite_key}"
  } else {
    $param_graphite_key = ''
  }

  cron { "graphite monitoring ${mysql_host}" :
    ensure  => $ensure,
    command => "/usr/local/bin/graphite_mysql_sender.php ${param_host} ${param_user} ${param_pass} ${param_port} ${param_graphite_host} ${param_graphite_port} ${param_graphite_key}",
    user    => 'root',
    hour    => '*',
    minute  => "*/${monitoring_interval}",

  }
}
