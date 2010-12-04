
use Test::More tests => 4;

use_ok('OpenData::Utils');

is(OpenData::Utils::class2suffix('Foo::Bar'), 'bar');
is(OpenData::Utils::class2suffix('Bar'), 'bar');
is(OpenData::Utils::class2suffix('Foo::Bar::Baz'), 'baz');


