node default
{
  include repos
  class {
    'mysql':
      type => 'percona';
  }
}
