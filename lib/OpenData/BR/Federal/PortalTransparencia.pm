

package OpenData::BR::Federal::PortalTransparencia;

use Moose::Role;
use OpenData::Array;

with 'OpenData::BR::Federal::PortalTransparencia::Servidores';
with 'OpenData::BR::Federal::PortalTransparencia::CEIS';
with 'OpenData::BR::Federal::PortalTransparencia::Convenios';

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
                ->new_with_traits(traits => 'MongoDB',
                    host => 'localhost',
                    );
        }
);

sub BUILD {
    my $self = shift;
#    $self->set_browser('Mechanize');
}

sub process {
    my $self = shift;

#    $self->items->collection('servidores');
#    $self->run_servidores;

#    $self->items->collection('ceis');
#    return $self->run_ceis;

     $self->items->collection('convenios');
     return $self->run_convenios;
}

1;


