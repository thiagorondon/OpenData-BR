
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose::Role;
use HTML::TreeBuilder::XPath;

my $baseurl = 'http://www.portaltransparencia.gov.br/servidores';
my $mainurl = join('/', $baseurl, 'Servidor-ListaServidores.asp');

sub _servidores_parse_member {
    my ($self, $url) = @_;
    my $people_url = join('/', $baseurl, $url);
    my $content = $self->get($people_url);

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
   
    warn 1;

    return (
        matricula       =>      '123456',
        cargo_emprego   =>      'TECNICO',
        classe          =>      3,
        padrao          =>      1,
        nivel           =>      5,
        orgao_origem    =>      '',
        uorg            =>      'FOO',
        orgao           =>      'BAR',
        orgao_superior  =>      'BAZ',
    );

}

sub _servidores_parse_tree () {
    my ($self, $html) = @_;

    my $link = $html->as_HTML;
    $link =~ s/^.*href=\"//;
    $link =~ s/\".*$//;
    return $self->_servidores_parse_member($link);
} 


sub servidores_init {
    my $self = shift;
    my @servidores;

    my $content = $self->get($mainurl);

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
   
    my $root = $tree->findnodes("//table");
    my $table = $root->[0]->as_HTML;

    $tree = HTML::TreeBuilder::XPath->new_from_content($table);
    $root = $tree->findnodes("//tr");
    
    $self->_servidores_parse_tree($_) for (@{$root});

    $tree->delete;
}

sub run_servidores {
    my $self = shift;
    $self->servidores_init;
}


1;

