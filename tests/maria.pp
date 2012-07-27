node default
{
  include repos

  class {
    'mysql':
      type => 'mariadb';
  }
}
