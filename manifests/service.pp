# Class: mysql::service
#
# This class provides the MySQL service
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
