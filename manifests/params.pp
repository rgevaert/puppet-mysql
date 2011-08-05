class mysql::params
{
  include pwgen

  $packages = $type ? {
    'oracle'  => [ 'mysql-server-5.1' ],
    'percona' => [ 'percona-server-server-5.5' ],
    'mariadb' => [ 'mariadb-server-5.3' ],
  } 

  $packages_extra = $type ? {
    'oracle'  => [ 'maatkit' ],
    'percona' => [ 'maatkit', 'xtrabackup' ],
    'mariadb' => [ 'maatkit'],
  } 

  $service = $type ? {
    'oracle'  => [ 'mysql' ],
    'percona' => [ 'mysql' ],
    'mariadb' => [ 'mysql' ],
  } 

  $password = $fqdn ? {
    'myhost1.example.com'  => 'test123',
    default                => pwgen(),
  }

  $multi_password = $fqdn ? {
    'myhost1.example.com'  => 'test123',
    default                => 'multipass',
  }
  
  $initscript = $mysql::multi ? {
    true   => 'puppet:///modules/mysql/init.multi',
    false =>  undef,
  }

  $notify_services = $fqdn ? {
    'myhost1.example.com'     => false,
    default                   => true 
  }
}
