class mysql::params
{
  $package_ensure = installed

  $packages = $mysql::type ? {
    'oracle'  => [ 'mysql-server-5.1' ],
    'percona' => [ 'percona-server-server-5.5' ],
    'mariadb' => [ 'mariadb-server-5.3' ],
  } 

  $packages_extra = $mysql::type ? {
    'oracle'  => [ 'maatkit' ],
    'percona' => [ 'maatkit', 'xtrabackup' ],
    'mariadb' => [ 'maatkit'],
  } 

  $service = $mysql::type ? {
    'oracle'  => [ 'mysql' ],
    'percona' => [ 'mysql' ],
    'mariadb' => [ 'mysql' ],
  } 
}
