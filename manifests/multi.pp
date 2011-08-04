class mysql::multi
{

  exec {
    "Shutdown legacy mysql":
      command => "/usr/bin/mysqladmin -S /var/run/mysqld/mysqld.sock shutdown",
      onlyif  => "/usr/bin/mysqladmin -S /var/run/mysqld/mysqld.sock ping",
  }

  file{
    "/etc/init.d/mysql":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 755,
      source  => $mysql::params::initscript;
    "/usr/sbin/mysqld_create_multi_instance":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 755,
      source  => "puppet:///modules/mysql/mysqld_create_multi_instance";
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
    require => [File['/etc/mysql/my.cnf'],File['/usr/sbin/mysqld_create_multi_instance']],
  }

  define instance( $bind_address,
                $port         = 3306,
                $socket       = "/var/run/mysqld/${name}.sock",
                $pid_file     = "/var/run/mysqld/${name}.pid",
                $datadir      = "/var/lib/${name}",
                $tmpdir       = "/var/tmp/${name}",
                $ensure       = "running"
              )
  {
    if($name !~ /^mysqld(\d)+$/)
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
      notify  => Service["${name}"],
    }

    exec {
      "setup_multi_${name}":
        command  => "/usr/sbin/mysqld_create_multi_instance --socket ${socket} --datadir ${datadir} --port ${port} --pid_file ${pid_file} --tmpdir ${tmpdir} --bind_address ${bind_address} --password ${mysql::params::multi_password}",
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

    $GNR = regsubst($name,'^mysqld(\d+)$','\1')
    service {
      "${name}" :
        ensure     => "${ensure}",
        hasrestart => true,
        hasstatus  => true,
        start      => "/etc/init.d/mysql start ${GNR}",
        restart    => "/etc/init.d/mysql restart ${GNR}",
        stop       => "/etc/init.d/mysql stop ${GNR}",
        status     => "/usr/bin/test -S /var/run/mysqld/${name}.sock",
        require    => Augeas['mysqld_multi'];
    }
  }
}
