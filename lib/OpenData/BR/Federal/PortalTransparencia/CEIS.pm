
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose;

use Data::Dumper;

with 'OpenData::Debug';
with 'OpenData::BR::Federal::PortalTransparencia::Base';
with 'OpenData::Provider::Collection';

use HTML::TreeBuilder::XPath;

has '+id'          => ( default => 'ceis', );
has '+name'        => ( default => 'CEIS', );
has '+description' => ( default => 'EMPRESAS SANCIONADAS', );

has '+mainURI' => (
    default => sub {
        my $baseURL = shift->baseURL || '';
        join( '/', $baseURL, 'ceis', 'EmpresasSancionadas.asp?paramEmpresa=0' );
    },
);

sub _transform {
    my ( $self, $content ) = @_;

    return unless $content;

    my $tree    = HTML::TreeBuilder::XPath->new_from_content($content);
    my $tr_list = $tree->findnodes("//table/tbody/tr");

    die 'Não conseguiu encontrar as tabelas com os dados no HTML'
      unless scalar( @{$tr_list} );

    my $data = [];

    foreach my $tr_item ( @{$tr_list} ) {
        #warn 'tr_item = '.Dumper($tr_item->as_HTML);
        my $tr =
          HTML::TreeBuilder::XPath->new_from_content( $tr_item->as_HTML );
        my $td_list = [ $tr->findvalues("//td") ];

        #warn Dumper($td_list);
        die 'Não conseguiu encontrar as colunas com os dados no HTML'
          unless scalar( @{$td_list} );

        my $line_data = {};

        $line_data->{cpfcnpj}           = $td_list->[0];
        $line_data->{nome}              = $td_list->[1];
        $line_data->{tipo}              = $td_list->[2];
        $line_data->{data_inicial}      = $td_list->[3];
        $line_data->{data_final}        = $td_list->[4];
        $line_data->{orgao_sancionador} = $td_list->[5];
        $line_data->{uf}                = $td_list->[6];
        $line_data->{fonte}             = $td_list->[7];
        $line_data->{fonte_data}        = $td_list->[8];

        $tr->delete;

        push @{$data}, $line_data;
    }
    $tree->delete;

    #warn Dumper($data);
    return $data ? $data : undef;
}

1;

