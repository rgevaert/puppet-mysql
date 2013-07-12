class mysql::params
{

  # default mysql type install
  $type = 'oracle'

  $package_ensure = installed

  $maatkit_package = $::lsbdistcodename ? {
    'wheezy' => 'percona-toolkit',
    default  => 'maatkit'
  }

  $packages_oracle  = [ 'mysql-server' ]
  $packages_percona = [ 'percona-server-server-5.5' ]
  $packages_mariadb = [ 'mariadb-server-5.3' ]

  $packages_extra_oracle  = [ $maatkit_package ]
  $packages_extra_percona = [ $maatkit_package, 'xtrabackup' ]
  $packages_extra_mariadb = [ $maatkit_package ]

  $service_oracle  = [ 'mysql' ]
  $service_percona = [ 'mysql' ]
  $service_mariadb = [ 'mysql' ]

}
