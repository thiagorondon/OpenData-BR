
use Test::More tests => 4;

use strict;

package Test;

use Moose;
with 'OpenData::Identifiable';

1;

package main;

my $obj = Test->new;
ok($obj);

ok( $obj->can('id') );
ok( $obj->can('name') );
ok( $obj->can('description') );

