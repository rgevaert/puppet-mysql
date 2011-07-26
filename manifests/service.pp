class mysql::service
{
  service {
    $mysql::params::service:
      enable     => true,
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
  }

  $mysql_password = $mysql::params::password

  # Is only run if the mysql server doesn't have a password.
  exec { "Set MySQL server root password":
      path        => "/bin:/usr/bin",
      # Only set password I no password is set.
      onlyif      => "mysqladmin --no-defaults -u root status",
      command     => "mysqladmin -u root password $mysql_password",
      require     => Service[$mysql::params::service],
      notify      => File['/root/.my.cnf'],
  }

  file { "/root/.my.cnf":
      ensure => present,
      owner   => root,
      group   => root,
      mode    => 600,
      content => template ("mysql/root-my.cnf.erb"),
      require => Exec["Set MySQL server root password"],
      replace => false,
  }

}