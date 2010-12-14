
use Test::More tests => 4;

use_ok( 'OpenData::AZ::Box::NOP' );

use OpenData::AZ::Box::NOP;

my $nop = OpenData::AZ::Box::NOP->new;
ok($nop);
ok($nop->process('yadayadayada') eq 'yadayadayada' );
ok($nop->process(42) == 42);
