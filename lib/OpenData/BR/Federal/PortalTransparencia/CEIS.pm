
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use URI;

my $baseurl = 'http://www.portaltransparencia.gov.br/ceis';
my $mainurl = join( '/', $baseurl, 'EmpresasSancionadas.asp?paramEmpresa=0' );

sub _ceis_parse_tree () {
    my ( $self, $content ) = @_;

    my $tree = HTML::TreeBuilder::XPath->new_from_content($content->as_HTML);
    my $root = $tree->findnodes("//td");

    my $data = {};
    my $loop = 0;

    foreach my $item (@{$root}) {
        my $line = $item->as_HTML;
        $line =~ s/\<t.*\">//g;
        $line =~ s/\<td>//g;
        $line =~ s/\<\/td>//g;

        $data->{cpfcnpj} = $line if $loop == 0;
        $data->{nome} = $line if $loop == 1;
        $data->{tipo} = $line if $loop == 2;
        $data->{data_inicial} = $line if $loop == 3;
        $data->{data_final} = $line if $loop == 4;
        $data->{orgao_sancionador} = $line if $loop == 5;
        $data->{uf} = $line if $loop == 6;
        $data->{fonte} = $line if $loop == 7;
        $data->{fonte_data} = $line if $loop == 8;

        $loop++;
    }

    return $data ? $data : undef;
}


sub _ceis_init {
    my $self = shift;
    my @ceis;

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
            my $member = $self->_ceis_parse_tree($obj);
            $self->items->add($member) if defined( $member->{nome} );
        }

        $tree->delete;

    }

    return $self->items;
}

sub _run_ceis { shift->_ceis_init; }

1;

