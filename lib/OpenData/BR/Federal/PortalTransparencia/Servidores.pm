
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose;
use OpenData::BR::Federal::PortalTransparencia::Servidores::ServidoresTransformer;

with 'OpenData::Debug';
with 'OpenData::Provider::Collection';

use Data::Dumper;

has '+id'          => ( default => 'servidores', );
has '+description' => ( default => 'Servidores', );

has '+extractor' => (
    lazy    => 1,
    default => sub {
        return OpenData::BR::Federal::PortalTransparencia::PageExtractor->new(
            mainURI => 'servidores/Servidor-ListaServidores.asp' );
    },
);

has '+transformer' => (
    lazy    => 1,
    default => sub {
        return
          OpenData::BR::Federal::PortalTransparencia::Servidores::ServidoresTransformer
          ->new;
    },
);

1;

