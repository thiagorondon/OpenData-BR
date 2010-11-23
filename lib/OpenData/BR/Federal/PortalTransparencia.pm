

package OpenData::BR::Federal::PortalTransparencia;

use Moose::Role;

with 'OpenData::BR::Federal::PortalTransparencia::Servidores';

has dept => (
    is => 'rw',
    isa => 'Str',
    default => 1
);

sub process {
    my $self = shift;

    return $self->run_servidores;

}

1;


