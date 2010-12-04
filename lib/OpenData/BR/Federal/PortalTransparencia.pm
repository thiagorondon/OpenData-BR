
package OpenData::BR::Federal::PortalTransparencia;

use Moose;
extends 'OpenData::Provider';

# Collections disponiveis.
use aliased 'OpenData::BR::Federal::PortalTransparencia::CEIS';
use aliased 'OpenData::BR::Federal::PortalTransparencia::Convenios';
use aliased 'OpenData::BR::Federal::PortalTransparencia::Servidores';

# Namespace  (TODO: Retirar isto)
has '+namespace' => ( default => 'OpenData::BR::Federal::PortalTransparencia' );

# Nome do provedor de dados
has '+name' => ( default => 'PortalTransparencia', );

# Descrição 
has '+description' => ( default => 'http://www.portaltransparencia.gov.br' );

# Loader que será utilizado.
has '+loader' => (
    default => sub { OpenData::Array->new_with_traits( traits => 'Dumper' ) }
);

1;

