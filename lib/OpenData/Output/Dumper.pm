

package OpenData::Output::Dumper;

use Moose::Role;
use Data::Dumper;

sub transform {
    my $self = shift;
    my $data = shift;
    return Dumper($data);
}

1;

