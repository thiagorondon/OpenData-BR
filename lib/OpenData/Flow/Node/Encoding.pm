
package OpenData::Flow::Node::Encoding;

use Moose;
extends 'OpenData::Flow::Node';

use Encode;

has 'input_encoding' => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_input_encoding',
);

has 'output_encoding' => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_output_encoding',
);

has '+process_item' => (
    default => sub {
        return sub {
            my ($me,$item) = @_;
            return $item unless ref($item) ne '';
            my $data = $me->has_input_encoding
                ? decode($me->input_encoding,$item)
                : $item;
            return $me->has_output_encoding
                ? encode($me->output_encoding, $data)
                : $data;
        }
    },
);

1;

