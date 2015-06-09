class mysql::install
{
  package {
    $mysql::_packages:
      ensure => $mysql::package_ensure;
    $mysql::packages_extra:
      ensure => $mysql::package_ensure;
  }

  file {
    '/usr/local/bin/mysql_secure_installation_socket':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => [ 'puppet:///modules/mysql/mysql_secure_installation_socket'];
  }
}
