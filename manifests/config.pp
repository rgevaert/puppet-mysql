# Configure mysql directories and config files
class mysql::config
{
  file {
    '/etc/mysql/':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    '/etc/mysql/conf.d/':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    '/var/lib/mysql':
      ensure  => directory,
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0755',
      require => Package[$mysql::_packages];
    '/etc/mysql/my.cnf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => [ "puppet:///modules/mysql/my.cnf-${mysql::mysql_type}" ],
      # we only install a config file if the package doesn't install one
      replace => false;
    '/etc/mysql/debian.cnf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600';
  }
}
