# This class install some scripts to poll an mysql instance.
# See also mysql::monitoring::cron
class mysql::monitoring {

  $packages = ['php5-cli', 'php5-mysql']

  ensure_packages($packages)

  file {
    '/usr/local/bin/graphite_mysql_sender.php':
      ensure  => present,
      owner   => 'root',
      group   => 'mysql',
      mode    => '0755',
      source  => 'puppet:///modules/mysql/monitoring/graphite_mysql_sender.php';
    '/usr/local/bin/ss_get_mysql_stats.php':
      ensure  => present,
      owner   => 'root',
      group   => 'mysql',
      mode    => '0755',
      source  => 'puppet:///modules/mysql/monitoring/ss_get_mysql_stats.php';
  }

}
