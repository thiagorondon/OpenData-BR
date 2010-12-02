use Test::More tests => 8;

use strict;

use OpenData::Transformer::Noop;

my $t = OpenData::Transformer::Noop->new;
ok($t);
can_ok($t,'transform');

ok($t->transform('anything') eq 'anything' );

ok($t->transform(42) == 42);

my $r = $t->transform( [qw/Up And Down/]);
ok( $r->[0] eq 'Up');
ok( $r->[1] eq 'And');
ok( $r->[2] eq 'Down');

ok( ! $t->transform(undef) );

