class mysql::install
{
  notice("install: ${mysql::params::packages}")

  package {
    $mysql::params::packages:
     ensure => installed;
    $mysql::params::packages_extra:
     ensure => installed;
  }
}
