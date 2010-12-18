
package OpenData::Flow::Box::LiteralData;

use Moose;
extends 'OpenData::Flow::Box::NOP';

has data => (
    is      => 'ro',
    isa     => 'Any',
    clearer => 'clear_data',
    predicate => 'has_data',
    required => 1,
    trigger => sub {
        my $self = shift;
        if( $self->has_data ) {
            $self->_enqueue_input( @_ );
            $self->clear_data;
        }
    },
);

override 'input' => sub { };

1;

