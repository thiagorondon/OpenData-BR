
use Test::More tests => 5;

use strict;
use OpenData::Output;

my $obj =
  OpenData::Output->new_with_traits( id => 'MongoDB', traits => 'MongoDB' );

is( $obj->{_trait_namespace}, 'OpenData::Output' );

ok( $obj->can('host') );
ok( $obj->can('database') );
ok( $obj->can('brother') );
ok( $obj->can('collection') );
