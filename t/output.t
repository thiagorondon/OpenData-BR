
use Test::More tests => 2;

use strict;

use_ok('OpenData::Output');

package OpenData::Output::Test;

    use Moose::Role;
    
    sub add {
        return 1;
    }

package main;

my $obj = OpenData::Output->new_with_traits(traits => 'Test');

ok($obj->can('add'));

1;


