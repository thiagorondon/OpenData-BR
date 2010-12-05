
package EGov::BR::Federal::PortalTransparencia::Convenios;

use Moose;
extends 'OpenData::Component';
with 'OpenData::Provider::Collection';

use aliased 'EGov::BR::Federal::PortalTransparencia::Convenios::Transformer';
use aliased 'EGov::BR::Federal::PortalTransparencia::PageExtractor';

my $uri = 'convenios/ConveniosListaGeral.asp?Ordem=-1';

has '+description' => ( default => 'Convênios', );

has '+extractor' => (
    lazy    => 1,
    default => sub { PageExtractor->new( mainURI => $uri ) },
);

has '+transformer' => (
    lazy    => 1,
    default => sub { Transformer->new; },
);

1;

