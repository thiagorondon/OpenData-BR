
package OpenData::BR::Federal::PortalTransparencia::Servidores;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use OpenData::Array;
use URI;

my $baseurl = 'http://www.portaltransparencia.gov.br/servidores';
my $mainurl = join( '/', $baseurl, 'Servidor-ListaServidores.asp' );

sub _servidores_parse_member {
    my ( $self, $url ) = @_;

    return if $url =~ /Pagina/;
    my $id = $url;
    $id =~ s/^.*IdServidor=//;

    my $people_url = join( '/', $baseurl, $url );
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
        
        #print $name . "\n";
        #print $item->as_HTML . "\n\n";
        
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

    my $content = $self->get( $mainurl );

    my $total_page = $self->_total_page($content);

    for my $i ( 1 .. $self->_total_page($content) ) {

        $self->debug("Paginacao, $i");
        $content = $self->get( $self->_page( $mainurl, $i ) );
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

sub _run_servidores { shift->_servidores_init; }

1;

