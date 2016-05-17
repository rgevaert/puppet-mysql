# Class: mysql::install
#
# This class will install your MySQL server package
class mysql::install
{
  package {
    $mysql::_packages:
      ensure => $mysql::package_ensure_real;
    $mysql::packages_extra:
      ensure => $mysql::package_ensure_real;
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
