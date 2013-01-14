class mysql::service
{
  service {
    $mysql::service:
      enable     => true,
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
  }
}
