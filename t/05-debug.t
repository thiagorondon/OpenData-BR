
use Test::More tests => 5;

use strict;

use_ok('OpenData::Debug');

package Debug;

use Moose;
with 'OpenData::Debug';

1;

package main;

my $debug = Debug->new;

ok( $debug->can('set_debug') );
$debug->set_debug;
is( $debug->is_debug, 1 );

ok( $debug->can('not_debug') );
$debug->not_debug;
is( $debug->is_debug, 0 );

1;

