class mysql ( $type='oracle')
{
  include mysql::params
  include mysql::repo
  include mysql::install
  include mysql::config
  include mysql::service

  Class['params'] ->
    Class['repo'] ->
    Class['install'] ->
    Class['config'] ->
    Class['service']
}
