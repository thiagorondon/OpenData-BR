use Test::More tests => 6;

use OpenData::Flow::Node;
use common::sense;

# tests: 1
my $uc =
  OpenData::Flow::Node->new(
    process_item => sub { shift; return uc(shift) },
    process_into => 1,
  );
ok($uc);

# tests: 2
my $val = 'yabadabadoo';
ok( $uc->process($val) eq 'YABADABADOO' );
my $res = $uc->process(\$val);
ok( $$res eq 'YABADABADOO' );

# tests: 1
my $aref = [ qw/ww xx yy zz/ ];
is_deeply( $uc->process($aref), [qw/WW XX YY ZZ/] );

# tests: 1
my $href = {
    11 => 'aa',
    22 => 'bb',
    33 => 'cc',
    44 => 'dd',
};
is_deeply( $uc->process($href), {
    11 => 'AA',
    22 => 'BB',
    33 => 'CC',
    44 => 'DD',
} );

# tests: 1
my $cref = sub { return 'ggg' };
ok( $uc->process($cref)->() eq 'GGG' );

