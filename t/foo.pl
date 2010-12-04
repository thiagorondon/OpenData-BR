
package Foo::Bar::Baz;
use Moose;
extends 'OpenData::Component';

1;

package main;

my $obj = Foo::Bar::Baz->new;
print $obj->component_name;
print $obj->is_debug;

