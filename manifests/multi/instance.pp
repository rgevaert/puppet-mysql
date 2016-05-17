# Class: mysql::multi::intance
#
# This class configures a new instances in a multi instance setup
class mysql::multi::instance ( $bind_address,
              $groupnr,
              $port                     = 3306,
              $socket                   = "/var/run/mysqld/${name}.sock",
              $pid_file                 = "/var/run/mysqld/${name}.pid",
              $datadir                  = "/var/lib/${name}",
              $tmpdir                   = "/var/tmp/${name}",
              $ensure                   = 'running',
              $server_id                = 1,
              $log_bin                  = "${name}-bin",
              $log_bin_index            = "${name}-bin.index",
              $relay_log                = "${name}-relay-bin",
              $relay_log_index          = "${name}-relay-bin.index",
              $expire_logs_days         = 10,
              $max_binlog_size          = '100M',
              $log_slave_updates        = true,
              $auto_increment_increment = 1,
              $auto_increment_offset    = 1,
              $key_buffer               = '16M',
              $max_allowed_packet       = '16M',
              $thread_stack             = '192K',
              $thread_cache_size        = '8',
              $max_connections          = 100,
              $table_cache              = 64,
              $table_open_cache         = false,
              $table_definition_cache   = false,
              $thread_concurrency       = 10,
              $max_connect_errors       = 10,
              #$innodb_log_file_size     = 5242880,
              $innodb_file_per_table    = false,
              $query_cache_type         = 1,
              $query_cache_size         = '16M',
            )
{

  if(!$mysql::multi)
  {
    fail('mysql::multi parameter must be true when defining an instance.')
  }

  if($groupnr !~ /^([0-9])+$/)
  {
    fail("groupnr ${groupnr} must be a postive integer.")
  }
  $instance = "mysqld${groupnr}"

  augeas { $instance:
    context => '/files/etc/mysql/my.cnf',
    changes => [
        "set target[ . = '${instance}'] ${instance}",
        "set target[ . = '${instance}']/bind-address ${bind_address}",
        "set target[ . = '${instance}']/socket ${socket}",
        "set target[ . = '${instance}']/port ${port}",
        "set target[ . = '${instance}']/pid-file ${pid_file}",
        "set target[ . = '${instance}']/datadir ${datadir}",
        "set target[ . = '${instance}']/tmpdir ${tmpdir}",
        "set target[ . = '${instance}']/server_id ${server_id} ",
        "set target[ . = '${instance}']/log_bin ${log_bin} ",
        "set target[ . = '${instance}']/log_bin_index ${log_bin_index}",
        "set target[ . = '${instance}']/relay_log ${relay_log}",
        "set target[ . = '${instance}']/relay_log_index ${relay_log_index}",
        "set target[ . = '${instance}']/expire_logs_days ${expire_logs_days}",
        "set target[ . = '${instance}']/max_binlog_size ${max_binlog_size}",
        "set target[ . = '${instance}']/log_slave_updates ${log_slave_updates} ",
        "set target[ . = '${instance}']/auto_increment_increment ${auto_increment_increment}",
        "set target[ . = '${instance}']/auto_increment_offset ${auto_increment_offset} ",
        "set target[ . = '${instance}']/key_buffer ${key_buffer}",
        "set target[ . = '${instance}']/max_allowed_packet ${max_allowed_packet}",
        "set target[ . = '${instance}']/thread_stack ${thread_stack}",
        "set target[ . = '${instance}']/thread_cache_size ${thread_cache_size}",
        "set target[ . = '${instance}']/max_connections ${max_connections}",
        "set target[ . = '${instance}']/thread_concurrency ${thread_concurrency}",
        "set target[ . = '${instance}']/max_connect_errors ${max_connect_errors}",
        "set target[ . = '${instance}']/query_cache_type ${query_cache_type}",
        "set target[ . = '${instance}']/query_cache_size ${query_cache_size}",
      ],
    require => Augeas['mysqld_multi'],
    notify  => Service[$instance],
  }

  # Vanaf percona server 5.5: table_cache vervangen door table_open_cache en table_definition_cache
  # Link naar docs toevoegen

  if ( $table_open_cache ) and ( $table_definition_cache ) {

    augeas { "${instance}-tablecachenew":
      context => '/files/etc/mysql/my.cnf',
      changes => [
        "set target[ . = '${instance}']/table_open_cache ${table_open_cache}",
        "set target[ . = '${instance}']/table_definition_cache ${table_definition_cache}",
      ],
      require => Augeas['mysqld_multi'],
      notify  => Service[$instance],
    }

  }
  else {
    augeas { "${instance}-tablecache":
      context => '/files/etc/mysql/my.cnf',
      changes => [
        "set target[ . = '${instance}']/table_cache ${table_cache}",
      ],
      require => Augeas['mysqld_multi'],
      notify  => Service[$instance],
    }
  }

#    if $innodb_log_file_size >= 0 {
#      augeas { "${instance}-innodb_log_file_size":
#        context => '/files/etc/mysql/my.cnf',
#        changes => [
#          "set target[ . = '${instance}']/innodb_log_file_size ${innodb_log_file_size}",
#        ],
#        require => Augeas['mysqld_multi'],
#        notify  => Service[$instance],
#      }
#    }

  if $innodb_file_per_table {
    augeas { "${instance}-innodb_file_per_table":
      context => '/files/etc/mysql/my.cnf',
      changes => [
        "set target[ . = '${instance}']/innodb_file_per_table ${innodb_file_per_table}",
      ],
      require => Augeas['mysqld_multi'],
      notify  => Service[$instance],
    }
  }

  exec {
    "setup_multi_${instance}":
      command  => "/usr/sbin/mysqld_create_multi_instance --socket ${socket} --datadir ${datadir} --port ${port} --pid_file ${pid_file} --tmpdir ${tmpdir} --bind_address ${bind_address} --password ${mysql::multi_password}",
      require  => Augeas[$instance],
      unless   => "/usr/bin/test -d ${datadir}";
  }

  file {
    $tmpdir:
      ensure  => directory,
      owner   => 'mysql',
      group   => 'mysql',
      mode    => '0755';
  }

  service {
    $instance:
      ensure     => $ensure,
      hasrestart => true,
      hasstatus  => true,
      start      => "/etc/init.d/mysql start ${groupnr}",
      restart    => "/etc/init.d/mysql restart ${groupnr}",
      stop       => "/etc/init.d/mysql stop ${groupnr}",
      status     => "/usr/bin/test -S ${socket}",
      require    => Augeas['mysqld_multi'];
  }
}
