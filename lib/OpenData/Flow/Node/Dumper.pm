
package OpenData::Flow::Node::Dumper;

use Moose;
extends 'OpenData::Flow::Node';

use Data::Dumper;

has '+process_item' => (
    default => sub {
        return sub { shift; print STDERR Dumper(shift); }
    }
);

1;

