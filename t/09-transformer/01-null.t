use Test::More tests => 7;

use strict;

use OpenData::Transformer::Null;

my $obj = OpenData::Transformer::Null->new;
ok($obj);
ok($obj->transform('anything') eq 'anything' );
ok($obj->transform(42) == 42);

my $r = $obj->transform( [qw/Up And Down/]);
ok( $r->[0] eq 'Up');
ok( $r->[1] eq 'And');
ok( $r->[2] eq 'Down');

ok( $t->transform(undef) == undef );

