
package OpenData::Transformer::Noop;

use Moose;

with 'OpenData::Transformer';

sub transform {
    my $self = shift;
    return wantarray? @_ : shift @_;
}

1;

