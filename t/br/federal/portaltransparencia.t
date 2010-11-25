
use Test::More tests => 5;

use strict;

use_ok('OpenData::BR::Federal::PortalTransparencia');

package A;

use Moose;

with 'OpenData::BR::Federal::PortalTransparencia';

sub _run_blablabla {
    return 42;
}

package main;

my $a = A->new();

eval { $a->_run };
ok( $@, 'Cannot run without setting a collection' );

$a->current_collection( 'pumpkins' );
eval { $a->_run };
ok( $@, 'Cannot run with an invalid collection' );

$a->current_collection( 'blablabla' );
eval { $a->_run };
ok( !$@, 'Passed valid run' );

ok( $a->_run == 42, 'Ran and returned right value' );


1;


