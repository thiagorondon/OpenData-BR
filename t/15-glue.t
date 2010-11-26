
use Test::More tests => 5;

use strict;

use_ok('OpenData::Glue');

my $dbpath = ':memory:';

my $obj = OpenData::Glue->new( dbfile => $dbpath );

is($obj->dbfile, $dbpath);

$obj->ev_create;

ok($obj->ev_save('foo', 'bar'));
ok($obj->ev_save('foo', 'baz'));
is($obj->ev_get('foo'), 'baz');

1;


