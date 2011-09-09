class mysql::install
{
  package {
    $mysql::params::packages:
     ensure => installed;
    $mysql::params::packages_extra:
     ensure => installed;
  }

  file {
    '/usr/local/bin/mysql_secure_installation_socket':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 755,
      source  => [ "puppet:///modules/mysql/mysql_secure_installation_socket" ];
  }
}
