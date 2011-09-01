class mysql::install
{
  package {
    $mysql::params::packages:
     ensure => installed;
    $mysql::params::packages_extra:
     ensure => installed;
  }
}
