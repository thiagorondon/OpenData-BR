
package EGov::BR::Federal::PortalTransparencia::CEIS;

use Moose;
extends 'OpenData::Component';
with 'OpenData::Provider::Collection';

use aliased 'EGov::BR::Federal::PortalTransparencia::PageExtractor';
use aliased 'EGov::BR::Federal::PortalTransparencia::CEIS::Transformer';

my $uri = 'ceis/EmpresasSancionadas.asp?paramEmpresa=0';

has '+description' =>
  ( default => 'CADASTRO DE EMPRESAS INIDÔNEAS OU SANCIONADAS', );

has '+extractor' => (
    lazy    => 1,
    default => sub { PageExtractor->new( mainURI => $uri ) }
);

has '+transformer' => (
    lazy    => 1,
    default => sub { Transformer->new; },
);

1;

