
use Test::More tests => 4;

use_ok( 'OpenData::Flow::Box::NOP' );

use OpenData::Flow::Box::NOP;

my $nop = OpenData::Flow::Box::NOP->new;
ok($nop);
ok($nop->process('yadayadayada') eq 'yadayadayada' );
ok($nop->process(42) == 42);
