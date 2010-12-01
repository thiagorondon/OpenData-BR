
package OpenData::Transformer::Chain;

use Moose;

with 'OpenData::Transformer';

has chain => (
    is  => 'ro',
    isa => 'ArrayRef[OpenData::Transformer]',
);

sub transform {
    my $self = shift;
    my $data = shift;

    die 'Must have at least two transformers in the chain!'
      unless scalar( @{ $self->chain } ) > 1;

    my $new = $data;

    foreach my $t ( @{ $self->chain } ) {
        $new = $t->transform($new);
    }

    return $new;
}

