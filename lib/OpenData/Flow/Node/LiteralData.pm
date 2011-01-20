
package OpenData::Flow::Node::LiteralData;

use Moose;
with ('MooseX::OneArgNew' => {
        type     => 'Any',
            init_arg => 'data',
              });

extends 'OpenData::Flow::Node::Null';

has data => (
    is        => 'ro',
    isa       => 'Any',
    clearer   => 'clear_data',
    predicate => 'has_data',
    required  => 1,
    trigger   => sub {
        my $self = shift;
        if ( $self->has_data ) {
            $self->_add_input(@_);
            $self->clear_data;
        }
    },
);

1;

