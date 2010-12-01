
use Test::More tests => 3;

use Test::Memory::Cycle;
use strict;

use_ok('OpenData::Runtime');

package OpenData::Test;
use Moose::Role;
use OpenData::Array;

has items => (
    is      => 'ro',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        return OpenData::Array->new_with_traits(
            traits => 'Dumper',
            host   => 'localhost',
        );
    }
);

sub process {
    return 1;
}

1;

package main;

my $obj = new OpenData::Runtime->with_traits('Test');

ok( $obj->process );

memory_cycle_ok($obj);
