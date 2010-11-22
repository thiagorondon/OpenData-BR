
use Test::More tests => 3;

use strict;

use_ok('OpenData::Get::Curl');

my $meta = OpenData::Get::Curl->meta;

ok($meta->has_method('get'), 'get method');
ok($meta->has_method('post'), 'post method');
1;





