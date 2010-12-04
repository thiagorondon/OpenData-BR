use Test::More tests => 10;

use strict;

package OneT;

    use Moose;
    with 'OpenData::Transformer';

    sub transform { 1 }

    1;

package Upper;

    use Moose;
    with 'OpenData::Transformer';

    sub transform {
        shift;
        return unless $_[0];
        return [ map { uc($_) } @{$_[0]} ];
    }

    1;

package main;

my $obj = OneT->new;
ok($obj);
ok($obj->transform( 'anything')  == 1);

my $a = [qw/aaa bbb ccc/];
my $t = Upper->new;
ok($t);

my $r = $t->transform([qw/Up And Down/]);
#use Data::Dumper;
#diag( Dumper($r) );

ok( $r->[0] eq 'UP');
ok( $r->[1] eq 'AND');
ok( $r->[2] eq 'DOWN');

my $r2 = $t->transform( $a );
ok( $r2->[0] eq 'AAA');
ok( $r2->[1] eq 'BBB');
ok( $r2->[2] eq 'CCC');

my $undef = $t->transform(undef);
#use Data::Dumper;
#diag( Dumper($undef) );
ok( !$undef );

