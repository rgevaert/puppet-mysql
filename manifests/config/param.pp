# Set mysql config file parameters
# Usage:
#
# mysql::config::param {
#    "serverid":
#      section => 'mysqld',
#      value   => '1';
# }
define mysql::config::param($section, $value, $param=$name)
{
  augeas { "${section}_${param}":
    context => '/files/etc/mysql/my.cnf',
    changes => [
        "set target[ . = '${section}'] ${section}",
        "set target[ . = '${section}']/${param} ${value}",
      ],
    require => File['/etc/mysql/my.cnf']
  }

  if($mysql::notify_services)
  {
    if($mysql::multi)
    {
      if($section =~ /^mysqld([1-9])+$/)
      {
        Augeas["${section}_${param}"] ~> Service[$section]
      }
    }else
    {
      Augeas["${section}_${param}"] ~> Class['mysql::service']
    }
  }
}
