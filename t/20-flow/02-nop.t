
use Test::More tests => 4;

use_ok( 'OpenData::Flow::Node::NOP' );

use OpenData::Flow::Node::NOP;

my $nop = OpenData::Flow::Node::NOP->new;
ok($nop);
ok($nop->process('yadayadayada') eq 'yadayadayada' );
ok($nop->process(42) == 42);
