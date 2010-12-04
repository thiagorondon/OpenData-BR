
use Test::More tests => 4;

use_ok('OpenData::Utils');

is(OpenData::Utils::class2suffix('Foo::Bar'), 'Bar');
is(OpenData::Utils::class2suffix('Bar'), 'Bar');
is(OpenData::Utils::class2suffix('Foo::Bar::Baz'), 'Baz');


