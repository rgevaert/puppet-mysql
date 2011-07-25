class mysql::service
{
  service {
    $mysql::params::service:
      enable     => true,
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
  }
}
