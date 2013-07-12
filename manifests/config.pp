class mysql::config
{
  file {
    '/etc/mysql/':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    '/etc/mysql/conf.d/':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';
    '/var/lib/mysql':
      ensure  => directory,
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0755',
      require => Package[$mysql::packages];
    '/etc/mysql/my.cnf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => [ "puppet:///modules/mysql/my.cnf-${mysql::type}" ],
      # we only install a config file if the package doesn't install one
      replace => false;
    '/etc/mysql/debian.cnf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0600';
  }

  define param($section, $value, $param=$name)
  {
    augeas { "${section}_${param}":
      context => '/files/etc/mysql/my.cnf',
      changes => [
          "set target[ . = '${section}'] ${section}",
          "set target[ . = '${section}']/${param} ${value}",
        ],
      require => File['/etc/mysql/my.cnf']
    }

    if($mysql::notify_services)
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
