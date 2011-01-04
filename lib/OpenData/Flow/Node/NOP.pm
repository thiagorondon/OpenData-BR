
package OpenData::Flow::Node::NOP;

use Moose;
extends 'OpenData::Flow::Node';

has '+process_item' => (
    default => sub {
        return sub { shift; return shift; }
    },
);

1;

