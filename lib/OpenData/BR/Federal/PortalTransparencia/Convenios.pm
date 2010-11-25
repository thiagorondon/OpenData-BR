
package OpenData::BR::Federal::PortalTransparencia::Convenios;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use OpenData::Array;
use URI;

my $baseurl = 'http://www.portaltransparencia.gov.br/convenios';
my $mainurl = join( '/', $baseurl, 'ConveniosListaGeral.asp?Ordem=-1' );

has convenios_page_start => (
    is => 'rw',
    isa => 'Int', 
    default => 1
);

sub _convenios_parse_member {
    my ( $self, $url ) = @_;
    return undef if $url =~ /convenios/; 
    $url =~ s/amp\;//g;

    my $people_url = join( '/', $baseurl, $url );
    my $content = $self->get($people_url);

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content);
    

    my $root = $tree->findnodes("//tr");

    my $data = {};

    my $loop = 0;
    foreach my $item ( @{$root} ) {
        my ($name, $value) = split (':', $item->as_text);
        $value ||= '';
        $value =~ s/^ *//;
        
        $data->{uf} = $value if $loop == 1;
        $data->{municipio} = $value if $loop == 2;
        
        if ($loop == 3) {
            $value =~ s/Saiba.*//;
            $data->{SIAFI} = $value;
        }
        
        $data->{situacao} = $value if $loop == 4;
        $data->{n_original} = $value if $loop == 5;
        $data->{objeto_do_convenio} = $value if $loop == 6;
        $data->{orgao_superior} = $value if $loop == 7;
        $data->{concedente} = $value if $loop == 8;
        $data->{convenente} = $value if $loop == 9;
        $data->{valor_convenio} = $value if $loop == 10;
        $data->{valor_liberado} = $value if $loop == 11;
        $data->{publicacao} = $value if $loop == 12;
        $data->{inicio_vigencia} = $value if $loop == 13;
        $data->{fim_vigencia} = $value if $loop == 14;
        $data->{valor_contrapartida} = $value if $loop == 15;
        $data->{data_ultima_liberacao} = $value if $loop == 16;
        $data->{valor_ultima_liberacao} = $value if $loop == 17;

        $loop++;
    }

    return $data ? $data : undef;

}

sub _convenios_parse_tree () {
    my ( $self, $html ) = @_;

    my $link = $html->as_HTML;
    $link =~ s/^.*href=\"//;
    $link =~ s/\".*$//;
    return $self->_convenios_parse_member($link);
}

sub _convenios_init {
    my $self = shift;
    my @convenios;

    my $content = $self->get( $mainurl );

    my $total_page = $self->_total_page($content);

    for my $i ( $self->convenios_page_start .. $self->_total_page($content) ) {

        $self->debug("Paginacao, $i");
        $content = $self->get( $self->_page( $mainurl, $i ) );
        my $tree  = HTML::TreeBuilder::XPath->new_from_content($content);
        my $root  = $tree->findnodes("//table");
        my $table = $root->[1]->as_HTML;

        $tree = HTML::TreeBuilder::XPath->new_from_content($table);
        $root = $tree->findnodes("//tr");

        foreach my $obj ( @{$root} ) {
            my $member = $self->_convenios_parse_tree($obj);
            $self->items->add($member) if defined( $member->{uf} );
        }

        $tree->delete;

    }

    return $self->items;
}

sub _run_convenios { shift->_convenios_init; }

1;

