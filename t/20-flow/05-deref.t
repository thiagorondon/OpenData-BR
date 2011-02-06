use Test::More tests => 11;

use strict;

use OpenData::Flow::Node;

# tests: 2
my $n = OpenData::Flow::Node->new(
    deref        => 1,
    process_item => sub { shift; return shift },
);
ok($n);
ok( $n->process_item->( $n, 'iop' ) eq 'iop' );

# tests: 2
# scalars
ok( !defined( $n->process() ) );
ok( $n->process('aaa') eq 'aaa' );

# tests: 1
# scalar refs
my $val = 'babaloo';
ok( $n->process( \$val ) eq 'babaloo' );

# tests: 2
# array refs
$n->input( [qw/aa bb cc dd ee ff gg hh ii jj/] );
ok( $n->output eq 'aa' );
ok( $n->output eq 'bb' );

#use Data::Dumper; diag( Dumper($n) );

# tests: 4
# hash refs
my %hashy = $n->output;
ok( $hashy{cc} eq 'dd' );
ok( $hashy{ee} eq 'ff' );
ok( $hashy{gg} eq 'hh' );
ok( $hashy{ii} eq 'jj' );

