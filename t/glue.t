
use Test::More tests => 5;

use strict;

use_ok('OpenData::Glue');

my $dbpath = '/tmp/gluedb';
unlink($dbpath);
die "$dbpath already exist." if -e $dbpath;

my $obj = OpenData::Glue->new( dbfile => $dbpath );

is($obj->dbfile, $dbpath);

$obj->ev_create;

die "dbpath doesnt exist" if ! -e $dbpath;

ok($obj->ev_save('foo', 'bar'));
ok($obj->ev_save('foo', 'baz'));
is($obj->ev_get('foo'), 'baz');
unlink($dbpath);

1;


