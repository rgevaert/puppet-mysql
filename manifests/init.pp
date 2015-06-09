# Class: mysql
#
# This module manages mysql.  It gives you the choice mysql
# server you want to use: oracle, mariadb or percona
#
# Parameters:
# - type: oracle|mariadb|percona
#
# Actions:
#
# Requires: camptocamp/apt rgevaert/pwgen
#
# Sample Usage:
# class {
#  mysql:
#    type => mariadb
# }
#
class mysql ( $type                           = $mysql::params::type,
              $notify_services                = true,
              $multi                          = false,
              $multi_password                 = 'multipass',
              $multi_initscript               = 'puppet:///modules/mysql/init.multi',
              $multi_create_instance_script   = 'puppet:///modules/mysql/create_instance',
              $package_ensure                 = $mysql::params::package_ensure,
              $manage_repo                    = true
              $packages                       = '')
inherits mysql::params {

  $_packages = $packages ? {
    ''      => $mysql::type ? {
      'oracle'  => $mysql::params::packages_oracle,
      'percona' => $mysql::params::packages_percona,
      'mariadb' => $mysql::params::packages_mariadb,
    },
    default => $packages
  }

  $packages_extra = $mysql::type ? {
    'oracle'  => $mysql::params::packages_extra_oracle,
    'percona' => $mysql::params::packages_extra_percona,
    'mariadb' => $mysql::params::packages_extra_mariadb,
  }

  $service = $mysql::type ? {
    'oracle'  => $mysql::params::service_oracle,
    'percona' => $mysql::params::service_percona,
    'mariadb' => $mysql::params::service_mariadb,
  }

  if($manage_repo)
  {
    class{'mysql::repo':;} ->
    class{'mysql::install':;}
  } else {
    class{'mysql::install':;}
  }

  if versioncmp($::augeasversion, '0.10.0') < 0 {
    # https://projects.puppetlabs.com/issues/11414
    fail('augeasversion must at least be 0.10.0')
  }

  if versioncmp($::puppetversion, '2.7.10') < 0 {
    # https://projects.puppetlabs.com/issues/11414
    fail('augeasversion must at least be 2.7.10')
  }

  if($multi)
  {
    class{'mysql::multi':;}
    class{'mysql::config':;}
  }
  else
  {
    class{'mysql::config':;}->
    class{'mysql::service':;}->
    class{'mysql::functions':;}
  }
}
