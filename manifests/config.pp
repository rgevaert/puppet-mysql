class mysql::config
{
  file {
    "/etc/mysql/":
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => 755;
    "/etc/mysql/conf.d/":
      ensure  => directory,
      owner   => root,
      group   => root,
      mode    => 755;
    "/var/lib/mysql":
      ensure  => directory,
      owner   => mysql,
      group   => mysql,
      mode    => 755;
    "/etc/mysql/my.cnf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 644,
      source  => [ "puppet:///modules/mysql/my.cnf-${type}" ],
      # we only install a config file if the package doesn't install one
      replace => false,
      notify  => $service_class;
    "/etc/mysql/debian.cnf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 600;
  }

  define param($section, $param=$name, $value)
  {
    augeas { "${section}_${param}":
      context => "/files/etc/mysql/my.cnf",
      changes => [
          "set target[ . = '${section}'] ${section}",
          "set target[ . = '${section}']/${param} ${value}",
        ],
      require => File['/etc/mysql/my.cnf']
    }
  
    if($mysql::params::notify_services)
    {
      if($mysql::multi)
      {
        if($section =~ /^mysqld([1-9])+$/)
        {
          Augeas["${section}_${param}"] ~> Service[$section]
        }
      }else
      {
        Augeas["${section}_${param}"] ~> Class['mysql::service']
      }
    }
  }
}
