use Test::More tests => 20;

use strict;

use OpenData::Flow::Node;

# tests: 2
diag('constructor and basic tests');
my $uc = OpenData::Flow::Node->new(
    process_item => sub {
        shift;
        return eval { uc(shift) };
    }
);
ok($uc);
ok( $uc->process_item->( $uc, 'iop' ) eq 'IOP' );

# tests: 4
# scalars
diag('scalar params');
my $undef = $uc->process();
ok( !$undef );
ok( $uc->process('aaa') eq 'AAA' );
ok( $uc->process('aaa') ne 'aaa' );
ok( $uc->process(1) == 1 );

# tests: 13
# array
diag('array params');
my @r = $uc->process(qw/all your base is belong to us/);
ok( $r[0] eq 'ALL' );
ok( $r[1] eq 'YOUR' );
ok( $r[2] eq 'BASE' );
ok( $r[3] eq 'IS' );
ok( $r[4] eq 'BELONG' );
ok( $r[5] eq 'TO' );
ok( $r[6] eq 'US' );
my ( $all, $your, $base ) = $uc->process(qw/all your base is belong to us/);
ok( $all  eq 'ALL' );
ok( $your eq 'YOUR' );
ok( $base eq 'BASE' );
my $undef2 = $uc->output;
ok( !$undef2 );
my $r1 = $uc->process(qw/all your base is belong to us/);
ok( $uc->output eq 'YOUR' );
ok( $uc->output eq 'BASE' );

$uc->flush;
ok( !$uc->output );

