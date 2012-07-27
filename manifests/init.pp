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
class mysql ( $type                           = 'oracle',
              $notify_services                = true,
              $multi                          = false,
              $multi_password                 = 'multipass',
              $multi_initscript               = 'puppet:///modules/mysql/init.multi',
              $multi_create_instance_script   = 'puppet:///modules/mysql/create_instance')
{
  include mysql::params
  include mysql::repo
  include mysql::install
  include mysql::config

  if versioncmp($::augeasversion, '0.10.0') < 0 {
    # https://projects.puppetlabs.com/issues/11414
    fail('augeasversion must at least be 0.10.0')
  }

  if versioncmp($::puppetversion, '2.7.10') < 0 {
    # https://projects.puppetlabs.com/issues/11414
    fail('augeasversion must at least be 2.7.10')
  }

  Class['params'] ->
    Class['repo'] ->
    Class['install'] ->
    Class['config']

  if($multi)
  {
    include mysql::multi
    Class['config'] -> Class['multi']
  }else
  {
    include mysql::service
    include mysql::functions
    Class['config'] -> Class['service'] -> Class['functions']
  }
}
