use Test::More tests => 6;

use strict;

use OpenData::Transformer::Null;

my $t = OpenData::Transformer::Null->new;
ok($t);
can_ok($t,'transform');

ok( !$t->transform('anything') );
ok( !$t->transform(42) );
ok( !$t->transform( [qw/Up And Down/]) );
ok( !$t->transform(undef) );

