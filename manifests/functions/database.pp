# Class: mysql::functions::database
#
# This class creates, imports or drops a database
define mysql::functions::database ( $ensure, $dump = NONE )
{
  case $ensure {
    'present': {
      exec { "MySQL: create ${name} db":
        command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";",
        unless  => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
        require => Class['mysql::install'],
      }
    }

    'importdb': {
      exec { 'MySQL: import db':
        command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";
              /usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf ${name} < ${dump}",
        require => Class['mysql::install'],
      }
    }

    'absent': {
      exec { "MySQL: drop ${name} db":
        command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"DROP DATABASE ${name}\";",
        onlyif  => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
        require => Class['mysql::install'],
      }
    }

    default: {
      fail "Invalid 'ensure' value '${ensure}' for mysql::database"
    }
  }
}
