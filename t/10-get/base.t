
use Test::More tests => 2;

use strict;

use_ok('OpenData::Get::Base');

my $meta = OpenData::Get::Base->meta;

is_deeply(
    [ sort $meta->get_attribute_list() ],
    [ 'agent', 'referer', 'timeout', 'try', 'url' ],
    '... got the right attribute list'
);

1;


