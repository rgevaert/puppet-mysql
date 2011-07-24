class mysql::service
{
  service {
    $mysql::params::service:
      ensure => running; 
  }
}
