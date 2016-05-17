# Class: mysql::muli
#
# This class initiates a multi instance mysql installation
class mysql::multi
{

  exec {
    'Shutdown legacy mysql':
      command => '/usr/bin/mysqladmin -S /var/run/mysqld/mysqld.sock shutdown',
      onlyif  => '/usr/bin/mysqladmin -S /var/run/mysqld/mysqld.sock ping',
  }

  file{
    '/etc/init.d/mysql':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => $mysql::multi_initscript;
    '/usr/sbin/mysqld_create_multi_instance':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      source  => $mysql::multi_create_instance_script;
  }

  augeas { 'mysqld_multi':
    context => '/files/etc/mysql/my.cnf',
    changes => [
        "set target[ . = 'mysqld_multi'] mysqld_multi",
        "set target[ . = 'mysqld_multi']/mysqld /usr/bin/mysqld_safe",
        "set target[ . = 'mysqld_multi']/mysqladmin /usr/bin/mysqladmin",
        "set target[ . = 'mysqld_multi']/log /var/log/mysql/mysqld_multi.log",
        "set target[ . = 'mysqld_multi']/user multi_admin",
        "set target[ . = 'mysqld_multi']/password ${mysql::multi_password}",
      ],
    require => [File['/etc/mysql/my.cnf'],File['/usr/sbin/mysqld_create_multi_instance'],File['/etc/init.d/mysql']],
  }

}
