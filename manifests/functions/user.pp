# Class: mysql::functions::user
#
# This class creates a user
define mysql::functions::user ( $password, $database, $host='localhost' )
{
  exec { "MySQL: create user ${name}":
    command => "/usr/bin/mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"GRANT ALL PRIVILEGES ON ${database}.* TO '${name}'@'${host}' IDENTIFIED BY '${password}' WITH GRANT OPTION;\";",
    require => Class['mysql::install'],
    unless  => "mysql --user=${name} --password=${password} --database=${database} --host=${host}",
  }
}
