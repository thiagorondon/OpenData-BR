
use Test::More tests => 18;

use strict;
use Scalar::Util qw/blessed reftype/;

package P;

    use Moose;
    with 'OpenData::AZ::Box';

    sub process_item {
        my ($self,$item) = @_;

        return eval { uc($item) };
    }

package main;

# tests: 1
my $obj = P->new;
ok($obj);

sub process_param {
    $obj->input(@_);
    return $obj->output;
}

# tests: 4
# scalars
my $undef = process_param();
ok( !$undef );
ok( process_param( 'aaa' ) eq 'AAA' );
ok( process_param( 'aaa' ) ne 'aaa' );
ok( process_param( 1 ) == 1 );

# tests: 13
# array
my @r = process_param( qw/all your base is belong to us/ );
ok( $r[0] eq 'ALL' );
ok( $r[1] eq 'YOUR' );
ok( $r[2] eq 'BASE' );
ok( $r[3] eq 'IS' );
ok( $r[4] eq 'BELONG' );
ok( $r[5] eq 'TO' );
ok( $r[6] eq 'US' );
my ($all, $your, $base) = process_param( qw/all your base is belong to us/ );
ok( $all eq 'ALL' );
ok( $your eq 'YOUR' );
ok( $base eq 'BASE' );
my $undef2 = $obj->output;
ok( !$undef2);
my $r1 = process_param( qw/all your base is belong to us/ );
#diag('r1     = ' . $r1);
ok( $obj->output eq 'YOUR' );
ok( $obj->output eq 'BASE' );
$obj->clear_queue;

