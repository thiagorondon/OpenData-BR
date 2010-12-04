
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose;

with 'OpenData::Log';
with 'OpenData::Provider::Collection';

use Data::Dumper;
use OpenData::BR::Federal::PortalTransparencia::PageExtractor;
use OpenData::BR::Federal::PortalTransparencia::CEIS::CEISTransformer;

has '+id' => ( default => 'ceis', );
has '+description' =>
  ( default => 'CADASTRO DE EMPRESAS INIDÔNEAS OU SANCIONADAS', );

has '+extractor' => (
    lazy    => 1,
    default => sub {
        return OpenData::BR::Federal::PortalTransparencia::PageExtractor->new(
            mainURI => 'ceis/EmpresasSancionadas.asp?paramEmpresa=0', );
    },
);

has '+transformer' => (
    lazy    => 1,
    default => sub {
        return
          OpenData::BR::Federal::PortalTransparencia::CEIS::CEISTransformer
          ->new;
    },
);

1;

