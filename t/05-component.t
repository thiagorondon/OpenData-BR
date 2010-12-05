
use Test::More tests => 2;

use strict;

package Test::Comp::Foo;

    use Moose;
    extends 'OpenData::Component';

    1;

package main;

my $obj = Test::Comp::Foo->new;

is($obj->component_name, 'Test::Comp::Foo');
ok($obj->can('dumper'));

