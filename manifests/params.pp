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

  $multi_password = $fqdn ? {
    'myhost1.example.com'  => 'test123',
    default                => 'multipass',
  }
  
  $initscript = $mysql::multi ? {
    true   => 'puppet:///modules/mysql/init.multi',
    false =>  undef,
  }

  if($mysql::multi){
    $create_instance_script = $fqdn ? {
      'myhost1.example.com'    => "puppet:///modules/mysql/create_instance.example.com",
      default                  => "puppet:///modules/mysql/create_instance",
    }
  }

  $notify_services = $fqdn ? {
    'myhost1.example.com'     => false,
    default                   => true 
  }
}
