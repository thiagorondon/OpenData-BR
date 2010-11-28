
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose;

use HTML::TreeBuilder::XPath;
use URI;

with 'OpenData::Provider::Collection';
with 'OpenData::BR::Federal::PortalTransparencia::Base';

has '+mainURI' => (
    default => 'EmpresasSancionadas.asp?paramEmpresa=0';
);

my $mainurl =
  join( '/', $baseurl, 'ceis', 'EmpresasSancionadas.asp?paramEmpresa=0' );

sub _extract {
    my $self    = shift;
    my $page    = $self->page;
    my $content = $self->get( $self->_page( $mainurl, $page ) );
    return unless $self->turn_page;    # empty if in last page
    return $content;
}

sub _transform {
    my ( $self, $content ) = @_;

    return unless $content;

    my $tree    = HTML::TreeBuilder::XPath->new_from_content($content);
    my $tr_list = $tree->findnodes("//table/tbody");

    die 'Não conseguiu encontrar as tabelas com os dados no HTML'
      if $#$tr_list == -1;

    my $data = [];

    foreach my $tr_item ( @{$tr_list} ) {
        my $tr =
          HTML::TreeBuilder::XPath->new_from_content( $tr_item->as_HTML )
          my $td_list = $tr->findvalue("./td");

        die 'Não conseguiu encontrar as colunas com os dados no HTML'
          if $#$td_list == -1;

        my $line_data = {};

        $line_data->{cpfcnpj}           = $td_list[0];
        $line_data->{nome}              = $td_list[1];
        $line_data->{tipo}              = $td_list[2];
        $line_data->{data_inicial}      = $td_list[3];
        $line_data->{data_final}        = $td_list[4];
        $line_data->{orgao_sancionador} = $td_list[5];
        $line_data->{uf}                = $td_list[6];
        $line_data->{fonte}             = $td_list[7];
        $line_data->{fonte_data}        = $td_list[8];

        $tr->delete;

        push @{$data}, $line_data;
    }
    $tree->delete;

    return $data ? $data : undef;
}

sub _load {
    my ($self,$data) = @_;

    $self->provider->loader->load($data);
}

1;

