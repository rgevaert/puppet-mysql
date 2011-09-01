class mysql::install
{
  package {
    $mysql::params::packages:
     ensure => installed;
    $mysql::params::packages_extra:
     ensure => installed;
  }

  file { 
    'secure_mysql':
      path   => "/usr/sbin/secure_mysql",
      ensure => present,
      owner  => root,
      mode   => 755,
      source => puppet:///modules/mysql/secure_mysql;
  }
}
