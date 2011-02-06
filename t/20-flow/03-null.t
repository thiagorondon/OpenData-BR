
use Test::More tests => 5;

use_ok('OpenData::Flow::Node::Null');

use OpenData::Flow::Node::Null;

my $nop = OpenData::Flow::Node::Null->new;
ok($nop);
ok( !defined( $nop->process('yadayadayada') ) );
ok( !defined( $nop->process(42) ) );
ok( !defined( $nop->process( [qw/a b c d e f g h i j/] ) ) );
