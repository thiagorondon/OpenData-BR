
package OpenData::BR::Federal::PortalTransparencia::Convenios;

use Moose;

with 'OpenData::Log';
with 'OpenData::Provider::Collection';

use Data::Dumper;
use OpenData::BR::Federal::PortalTransparencia::PageExtractor;
use OpenData::BR::Federal::PortalTransparencia::Convenios::ConveniosTransformer;

has '+id'          => ( default => 'convenios', );
has '+description' => ( default => 'Convênios', );

has '+extractor' => (
    lazy    => 1,
    default => sub {
        return OpenData::BR::Federal::PortalTransparencia::PageExtractor->new(
            mainURI => 'convenios/ConveniosListaGeral.asp?Ordem=-1' );
    },
);

has '+transformer' => (
    lazy    => 1,
    default => sub {
        return
          OpenData::BR::Federal::PortalTransparencia::Convenios::ConveniosTransformer
          ->new;
    },
);

1;

