
use Test::More tests => 12;

use strict;

use_ok('OpenData::Array');

my $item = OpenData::Array->new;

can_ok($item, $_) for qw[
    all
    add 
    map
    filter 
    find 
    get
    join
    count
    has 
    empty
    sorted
];

1;


