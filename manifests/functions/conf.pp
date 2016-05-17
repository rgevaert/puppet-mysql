# Class: mysql::functions::conf
#
# This class puts a extra config file in place
define mysql::functions::conf ($ensure, $config = $name)
{
  case $ensure {
    present: {
      file { "/etc/mysql/conf.d/${name}.cnf":
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        content => template ("mysql/${name}.cnf.erb"),
        require => Class['config'],
      }
    }

    absent: {
      file { "/etc/mysql/conf.d/${name}.cnf":
        ensure  => absent,
        require => Class['config'],
      }
    }

    default: {
      fail ("Unknown ensure value ${ensure}")
    }
  }
}
