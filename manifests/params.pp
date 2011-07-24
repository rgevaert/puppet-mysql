class mysql::params
{
  notice("type: $type")

  $packages = $type ? {
    'oracle'  => [ 'mysql-server-5.1' ],
    'percona' => [ 'percona-server-server-5.5' ],
    'mariadb' => [ 'mariadb-server-5.3' ],
  } 

  $service = $type ? {
    'oracle'  => [ 'mysql' ],
    'percona' => [ 'mysql' ],
    'mariadb' => [ 'mysql' ],
  } 
}
