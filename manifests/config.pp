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
      notify  => Class["mysql::service"];
    "/etc/mysql/debian.cnf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 600;
  }

  if($multi)
  {
    file{
      "/etc/init.d/mysql":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => 755,
        source  => $mysql::params::initscript;
    }

    augeas { "mysqld_multi":
      context => "/files/etc/mysql/my.cnf",
      changes => [
          "set target[ . = 'mysqld_multi'] mysqld_multi",
          "set target[ . = 'mysqld_multi']/mysqld /usr/bin/mysqld_safe",
          "set target[ . = 'mysqld_multi']/mysqladmin /usr/bin/mysqladmin",
          "set target[ . = 'mysqld_multi']/log /var/log/mysql/mysqld_multi.log",
          "set target[ . = 'mysqld_multi']/user multi_admin",
          "set target[ . = 'mysqld_multi']/password ${mysql::params::multi_password}",
        ],
      require => File['/etc/mysql/my.cnf'],
    }
  }

  define param($section, $param=$name, $value)
  {
    augeas { "${section}_${param}":
      context => "/files/etc/mysql/my.cnf",
      changes => [
          "set target[ . = '${section}'] ${section}",
          "set target[ . = '${section}']/${param} ${value}",
        ],
      require => File['/etc/mysql/my.cnf'],
    }
  }

  define multi( $bind_address,
                $port         = 3306,
                $socket       = "/var/run/mysqld/${name}.sock",
                $pid_file     = "/var/run/mysqld/${name}.pid",
                $datadir     = "/var/lib/${name}",
                $tmpdir       = "/var/tmp/${name}"
              )
  {

    if $name !~ /^mysqld(\d)+$/
    {
      error("name must by like mysqld[x], where x is a number.")
    }

    augeas { "${name}":
      context => "/files/etc/mysql/my.cnf",
      changes => [
          "set target[ . = '$name'] $name",
          "set target[ . = '$name']/bind-address $bind_address",
          "set target[ . = '$name']/socket $socket",
          "set target[ . = '$name']/port $port",
          "set target[ . = '$name']/pid-file $pid_file",
          "set target[ . = '$name']/datadir $datadir",
          "set target[ . = '$name']/tmpdir $tmpdir",
        ],
      require => Augeas['mysqld_multi'],
    }

    exec {
      "setup_multi_${name}":
        command  => "/etc/puppet/modules/mysql/files/mysqld_create_multi_instance --socket ${socket} --datadir ${datadir} --port ${port} --pid_file ${pid_file} --tmpdir ${tmpdir} --bind_address ${bind_address} --password ${mysql::params::multi_password}",
        require => Augeas["${name}"],
        unless   => "/usr/bin/test -d ${datadir}";
    }

    file {
      "${tmpdir}":
        ensure  => directory,
        owner   => mysql,
        group   => mysql,
        mode    => 755;
    }
  }
}
