
use Test::More tests => 1;

use strict;

package Test;

    use Moose;
    with 'OpenData::Transformer';

    sub transform { 1 }

    1;

package main;

my $obj = Test->new;
ok($obj);

