
use Test::More tests => 1;

use strict;

use_ok('OpenData::Array');

my $item = OpenData::Array->new;


1;

__END__

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


