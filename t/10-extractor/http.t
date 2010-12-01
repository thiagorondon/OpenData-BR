
use Test::More tests => 5;

use strict;

use_ok('OpenData::Extractor::HTTP');

my $obj;

eval { $obj = OpenData::Extractor::HTTP->new };
ok($@);

$obj = OpenData::Extractor::HTTP->new(URL => 'http://localhost');
isa_ok($obj, 'OpenData::Extractor::HTTP');

ok($obj->set_browser('Mechanize'));

isa_ok($obj->obj, 'WWW::Mechanize');

1;

