
package OpenData::Output::Dumper;

use Moose::Role;
use Data::Dumper;

sub add {
    my $self = shift;
    my $data = shift;
    print Dumper($data);
}

sub load {
    shift->add(shift);
}

1;

