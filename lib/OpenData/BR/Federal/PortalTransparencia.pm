

package OpenData::BR::Federal::PortalTransparencia;

use Moose::Role;
use OpenData::Array;

with 'OpenData::BR::Federal::PortalTransparencia::Servidores';

has dept => (
    is => 'rw',
    isa => 'Str',
    default => 1
);

has items => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
            return OpenData::Array
                ->new_with_traits(traits => 'MongoDB');
        }
);

sub BUILD {
    my $self = shift;
#    $self->set_browser('Mechanize');
}

sub process {
    my $self = shift;

    return $self->run_servidores;

}

1;


