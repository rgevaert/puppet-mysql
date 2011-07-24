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
      mode    => 700;
    "/etc/mysql/my.cnf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 644,
      source  => [ "puppet:///modules/mysql/my.cnf-${fqdn}", "puppet:///modules/mysql/my.cnf-${type}" ],
      notify  => Class["mysql::service"];
    "/etc/mysql/debian.cnf":
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => 600,
  }
}
