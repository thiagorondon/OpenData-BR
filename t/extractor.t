
use Test::More tests => 1;

use strict;

package OnlyTest;

    use Moose;
    with 'OpenData::Extractor';

    sub extract { 1 }

    1;

package main;

my $obj = OnlyTest->new;
ok($obj);

