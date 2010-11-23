
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use OpenData::Array;

has baseurl => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://www.portaltransparencia.gov.br/servidores'
);

has mainurl => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { join('/', shift->baseurl, 'Servidor-ListaServidores.asp') }
);

sub _servidores_parse_member {
    my ($self, $url) = @_;
    my $people_url = join('/', $self->baseurl, $url);
    my $content = $self->get($people_url);

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
   
    my $root = $tree->findnodes("//tr");
    foreach my $item (@{$root}) {
        print $item->as_text . "\n";
    }

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

    my $content = $self->get($self->mainurl);
    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
    my $root = $tree->findnodes("//table");
    my $table = $root->[0]->as_HTML;
    my $items = OpenData::Array->new;

    $tree = HTML::TreeBuilder::XPath->new_from_content($table);
    $root = $tree->findnodes("//tr");
    
    $items->add($self->_servidores_parse_tree($_)) for (@{$root});
    
    $tree->delete;
    
    return $items->all;
}

sub run_servidores {
    my $self = shift;
    return $self->servidores_init;
}

1;

