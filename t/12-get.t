
use Test::More tests => 3;

use strict;

use_ok('OpenData::Get');

use OpenData::Get;

my $get = OpenData::Get->new;
ok($get);

my $html = $get->get( q{http://www.kernel.org/} );
#diag(q{html = } . $html);
ok($html);

1;

