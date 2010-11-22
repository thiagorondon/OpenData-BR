

package OpenData::BR::Federal::PortalTransparencia;

use Moose::Role;

with 'OpenData::BR::Federal::PortalTransparencia::Servidores';

has servidores => (
    is => 'ro',
    isa => 'Int',
    default => 1
);

sub process {
    my $self = shift;

    if ($self->servidores) {
        $self->run_servidores;
    }

}

1;


