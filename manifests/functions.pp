class mysql::functions
{
  define database ( $ensure, $dump = NONE )
  {
    case $ensure {
      present: {
        exec { "MySQL: create $name db":
          command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";",
          unless  => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
          require => Class["mysql::install"],
        }
      }

      importdb: {
        exec { "MySQL: import db":
          command   => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"CREATE DATABASE ${name}\";
                /usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf ${name} < ${dump}",
          require   => Class["mysql::install"],
        }
      }

      absent: {
        exec { "MySQL: drop $name db":
          command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"DROP DATABASE ${name}\";",
          onlyif  => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES;\" | grep -x '${name}'",
          require => Class["mysql::install"],
        }
      }

      default: {
        fail "Invalid 'ensure' value '$ensure' for mysql::database"
      }
    }
  }

  define user ( $password, $database, $host="localhost" )
  {
    exec { "MySQL: create user $name":
      command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"GRANT ALL PRIVILEGES ON ${database}.* TO '${name}'@'${host}' IDENTIFIED BY '${password}' WITH GRANT OPTION;\";",
      require => Class["mysql::install"],
      unless  => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf mysql --execute=\"SELECT * FROM user where User = '${name}';\"",
    }
  }

  define conf ( $config = $name, $ensure ) 
  {
    case $ensure {
      present: {
        file { "/etc/mysql/conf.d/${name}.cnf":
          ensure  => present,
          owner   => root,
          group   => root,
          mode  => 600,
          content => template ("mysql/${name}.cnf.erb"),
          require => Class["config"],
        }
      }
      
      absent: {
        file { "/etc/mysql/conf.d/${name}.cnf":
          ensure  => absent,
          require => Class["config"],
        }
      }
    }
  }
}