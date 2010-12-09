
package EGov::BR::Federal::PortalTransparencia::Servidores;

use Moose;
extends 'OpenData::Component';
with 'OpenData::Provider::Collection';

use aliased 'EGov::BR::Federal::PortalTransparencia::Servidores::Transformer';
use aliased 'EGov::BR::Federal::PortalTransparencia::PageExtractor';

my $uri = 'servidores/Servidor-ListaServidores.asp';

has '+description' => ( default => 'Servidores', );

has '+extractor' => (
    lazy    => 1,
    default => sub { PageExtractor->new( mainURI => $uri ) }
);

has '+transformer' => (
    lazy    => 1,
    default => sub { Transformer->new }
);

1;

