
package OpenData::Flow::Node::LiteralData;

use Moose;
extends 'OpenData::Flow::Node::NOP';

has data => (
    is        => 'ro',
    isa       => 'Any',
    clearer   => 'clear_data',
    predicate => 'has_data',
    required  => 1,
    trigger   => sub {
        my $self = shift;
        if ( $self->has_data ) {
            $self->_enqueue_input(@_);
            $self->clear_data;
        }
    },
);

override 'input' => sub { };

1;

