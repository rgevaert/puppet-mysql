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
      source  => "${mysql::params::create_instance_script}";
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
    require => [File['/etc/mysql/my.cnf'],File['/usr/sbin/mysqld_create_multi_instance'],File['/etc/init.d/mysql']],
  }

  define instance( $bind_address,
                $groupnr,
                $port         = 3306,
                $socket       = "/var/run/mysqld/${name}.sock",
                $pid_file     = "/var/run/mysqld/${name}.pid",
                $datadir      = "/var/lib/${name}",
                $tmpdir       = "/var/tmp/${name}",
                $ensure       = "running"
              )
  {
    if($groupnr !~ /^([1-9])+$/)
    {
      error("groupnr must be a postive integer.")
    }
    $instance = "mysqld${groupnr}"

    augeas { "${instance}":
      context => "/files/etc/mysql/my.cnf",
      changes => [
          "set target[ . = '$instance'] $instance",
          "set target[ . = '$instance']/bind-address $bind_address",
          "set target[ . = '$instance']/socket $socket",
          "set target[ . = '$instance']/port $port",
          "set target[ . = '$instance']/pid-file $pid_file",
          "set target[ . = '$instance']/datadir $datadir",
          "set target[ . = '$instance']/tmpdir $tmpdir",
        ],
      require => Augeas['mysqld_multi'],
      notify  => Service["${instance}"],
    }

    exec {
      "setup_multi_${instance}":
        command  => "/usr/sbin/mysqld_create_multi_instance --socket ${socket} --datadir ${datadir} --port ${port} --pid_file ${pid_file} --tmpdir ${tmpdir} --bind_address ${bind_address} --password ${mysql::params::multi_password}",
        require => Augeas["${instance}"],
        unless   => "/usr/bin/test -d ${datadir}";
    }


    file {
      "${tmpdir}":
        ensure  => directory,
        owner   => mysql,
        group   => mysql,
        mode    => 755;
    }

    service {
      "${instance}" :
        ensure     => "${ensure}",
        hasrestart => true,
        hasstatus  => true,
        start      => "/etc/init.d/mysql start ${groupnr}",
        restart    => "/etc/init.d/mysql restart ${groupnr}",
        stop       => "/etc/init.d/mysql stop ${groupnr}",
        status     => "/usr/bin/test -S ${socket}",
        require    => Augeas['mysqld_multi'];
    }
  }
}
