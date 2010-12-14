
package OpenData::AZ::Box::NOP;

use Moose;
extends 'OpenData::AZ::Box';

has '+process_item' => (
    default => sub {
        return sub { shift; return shift; }
    },
);

1;

