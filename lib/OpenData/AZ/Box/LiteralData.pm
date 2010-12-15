
package OpenData::AZ::Box::LiteralData;

use Moose;
extends 'OpenData::AZ::Box::NOP';

has data => (
    is      => 'ro',
    isa     => 'Any',
    clearer => 'clear_data',
    predicate => 'has_data',
    required => 1,
    trigger => sub {
        my $self = shift;
        if( $self->has_data ) {
            $self->enqueue( @_ );
            $self->clear_data;
        }
    },
);

override 'input' => sub { };

1;

