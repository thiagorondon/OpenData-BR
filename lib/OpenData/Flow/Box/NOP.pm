
package OpenData::Flow::Box::NOP;

use Moose;
extends 'OpenData::Flow::Box';

has '+process_item' => (
    default => sub {
        return sub { shift; return shift; }
    },
);

1;

