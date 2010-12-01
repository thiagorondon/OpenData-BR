
package OpenData::Transformer::Chain;

use Moose;

with 'OpenData::Transformer';

has links => (
    is  => 'ro',
    isa => 'ArrayRef[OpenData::Transformer]',
);

sub transform {
    my $self = shift;
    my $data = shift;

    die 'Must have at least two transformers in the chain!'
      unless scalar( @{ $self->links } ) > 1;

    my $new = $data;

    foreach my $l ( @{ $self->links } ) {
        $new = $l->transform($new);
    }

    return $new;
}

1;

