# Class: mysql::repo
#
# This class configures the APT repo for the chosen flavour of MySQL
class mysql::repo
{
  include ::apt

  case $mysql::type{
    'oracle' : { # use standard packages
    }

    'percona': {
      apt::key {
        'CD2EFD2A':
      }

      apt::sources_list {'percona':
          ensure  => present,
          content => "deb http://repo.percona.com/apt ${::lsbdistcodename} main",
          require => Apt::Key['CD2EFD2A'],
      }
    }

    'mariadb': {
      apt::key {
        '1BB943DB':
      }

      apt::sources_list {'mariadb5.3':
          ensure  => present,
          content => "deb http://mirror2.hs-esslingen.de/mariadb/repo/5.3/debian ${::lsbdistcodename} main",
          require => Apt::Key['1BB943DB'],
      }
    }

    default: {
      fail('Undefined mysql server type')
    }
  }
}
