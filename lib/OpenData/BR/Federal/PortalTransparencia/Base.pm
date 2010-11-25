
package BR::Federal::PortalTransparencia::Base;

use Moose::Role;


has baseURL => (
    is  => 'ro',
    isa => 'Str',
    default => 'http://www.portaltransparencia.gov.br/ceis',
    );

has mainURI => (
    is => 'ro',
    isa => 'Str',
);

has mainURL => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my $self = shift;
        return join( '/', $self->baseURL, $self->mainURI );
    },
    );

