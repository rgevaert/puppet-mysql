node default
{
  include repos
  class {
    'mysql':
      type => 'percona';
  }

  mysql::multi::instance{
    'mysqld1':
      groupnr      => 1,
      bind_address => '0.0.0.0',
      port         => 3307;
    'mysqld2':
      groupnr      => 2,
      bind_address => '0.0.0.0',
      port         => 3308;
    'mysqld3':
      groupnr      => 3,
      bind_address => '0.0.0.0',
      port         => 3309,
      ensure       => 'stopped';
  }

}
