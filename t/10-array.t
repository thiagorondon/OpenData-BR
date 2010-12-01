
use Test::More tests => 2;

use strict;

use_ok('OpenData::Array');

my $item = OpenData::Array->new;
isa_ok( $item, 'OpenData::Array' );
