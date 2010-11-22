
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose::Role;

sub servidores_init {
    my $self = shift;
    my $url = "http://www.portaltransparencia.gov.br/servidores/Servidor-ListaServidores.asp";

    my $content = $self->get($url);
    warn $content;


}

sub run_servidores {
    my $self = shift;
    $self->servidores_init;
}


1;

