
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use OpenData::Array;
use URI;

has baseurl => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://www.portaltransparencia.gov.br/servidores'
);

has mainurl => (
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
    default =>
      sub { join( '/', shift->baseurl, 'Servidor-ListaServidores.asp' ) }
);

sub _servidores_parse_member {
    my ( $self, $url ) = @_;

    return if $url =~ /Pagina/;
    my $id = $url;
    $id =~ s/^.*IdServidor=//;

    my $people_url = join( '/', $self->baseurl, $url );
    my $content = $self->get($people_url);

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
    my $root = $tree->findnodes("//tr");

    my $data = {};
    $data->{id} = $id;

    foreach my $item ( @{$root} ) {
        my $line = $item->as_text;
        $line =~ s/ *//;
        my ( $name, $value ) = split( /:/, $line );
        $value =~ s/ *// if $value;
        $data->{nome} = $value if $name eq 'Nome';
        $data->{cpf}  = $value if $name eq 'CPF';
    }

    return $data ? $data : undef;

}

sub _servidores_parse_tree () {
    my ( $self, $html ) = @_;

    my $link = $html->as_HTML;
    $link =~ s/^.*href=\"//;
    $link =~ s/\".*$//;
    return $self->_servidores_parse_member($link);
}

sub _servidores_init {
    my $self = shift;
    my @servidores;

    my $content = $self->get( $self->mainurl );

    my $total_page = $self->_total_page($content);

    for my $i ( 1 .. $self->_total_page($content) ) {

        $self->debug("Paginacao, $i");
        $content = $self->get( $self->_page( $self->mainurl, $i ) );
        my $tree  = HTML::TreeBuilder::XPath->new_from_content($content);
        my $root  = $tree->findnodes("//table");
        my $table = $root->[0]->as_HTML;

        $tree = HTML::TreeBuilder::XPath->new_from_content($table);
        $root = $tree->findnodes("//tr");

        foreach my $obj ( @{$root} ) {
            my $member = $self->_servidores_parse_tree($obj);
            $self->items->add($member) if defined( $member->{nome} );
        }

        $tree->delete;

    }

    return $self->items;
}

sub _page {
    my ( $self, $url, $numero ) = @_;
    my $u = URI->new($url);
    $u->query_form( Pagina => $numero );
    return $u->as_string;
}

sub _total_page {
    my ( $self, $html ) = @_;
    my $numero =
      HTML::TreeBuilder::XPath->new_from_content($html)
      ->findnodes('//p[@class="paginaAtual"]')->[0];
    if ($numero) {
        my $total = $numero->as_text;
        $numero->delete;
        return $1 if $total =~ /\d\/(\d+)/;
    }
    else {
        die "Não conseguiu fazer a paginação";
    }
}

sub run_servidores { shift->_servidores_init; }

1;

