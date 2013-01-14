class mysql::params
{

  # default mysql type install
  $type = 'oracle' 

  $package_ensure = installed

  $packages_oracle  = [ 'mysql-server-5.1' ]
  $packages_percona = [ 'percona-server-server-5.5' ]
  $packages_mariadb = [ 'mariadb-server-5.3' ]

  $packages_extra_oracle  = [ 'maatkit' ]
  $packages_extra_percona = [ 'maatkit', 'xtrabackup' ]
  $packages_extra_mariadb = [ 'maatkit']

  $service_oracle  = [ 'mysql' ]
  $service_oracle  = [ 'mysql' ]
  $service_mariadb = [ 'mysql' ]

}
