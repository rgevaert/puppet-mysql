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
class mysql ( $type='oracle', $multi=false)
{
  include mysql::params
  include mysql::repo
  include mysql::install
  include mysql::config
  include mysql::service

  Class['params'] ->
    Class['repo'] ->
    Class['install'] ->
    Class['config'] ->
    Class['service']
}
