
use Test::More tests => 11;

use strict;

use_ok('OpenData::Log');

package TestLog;

    use Moose;
    with 'OpenData::Log';

    1;

package main;

my $logger = TestLog->new;

can_ok($logger, 'enable');

for my $item (qw[ debug info warn error fatal ]) {
    can_ok($logger, $item);
    can_ok($logger, "is_$item");
}

warn $logger->is_debug;

$logger->debug('foo');

