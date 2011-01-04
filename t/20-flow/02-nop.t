
use Test::More tests => 6;

use_ok('OpenData::Flow::Node::NOP');

use OpenData::Flow::Node::NOP;

my $nop = OpenData::Flow::Node::NOP->new;
ok($nop);
ok( !defined( $nop->process() ) );
ok( $nop->process('yadayadayada') eq 'yadayadayada' );
ok( $nop->process(42) == 42 );
ok( $nop->process( [qw/a b c d e f g h i j/] )->[9] eq 'j' );
