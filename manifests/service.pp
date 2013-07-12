class mysql::service
{
  service {
    $mysql::service:
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
  }
}
