
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose;

with 'OpenData::Debug';
with 'OpenData::BR::Federal::PortalTransparencia::Base';
with 'OpenData::Provider::Collection';

use Data::Dumper;
use List::MoreUtils qw/mesh/;
use HTML::TreeBuilder::XPath;

has '+id' => ( default => 'ceis', );
has '+description' =>
  ( default => 'CADASTRO DE EMPRESAS INIDÔNEAS OU SANCIONADAS', );

has '+mainURI' => (
    default => sub {
        join( '/', 'ceis', 'EmpresasSancionadas.asp?paramEmpresa=0' );
    },
);

has '+elements_list' => (
    default => sub {
        return [
            qw/cpfcnpj nome tipo data_inicial data_final orgao_sancionador
              uf fonte fonte_data/
        ];
    },
);

sub _transform {
    my ( $self, $content ) = @_;

    my $data = [];
    foreach my $page ( @{$content} ) {
        my $tree    = HTML::TreeBuilder::XPath->new_from_content($page);
        my $tr_list = $tree->findnodes(
            '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr');

        die 'Não conseguiu encontrar as tabelas com os dados no HTML'
          unless scalar( @{$tr_list} );

        foreach my $tr_item ( @{$tr_list} ) {

            #warn 'tr_item = '.Dumper($tr_item->as_HTML);
            my $tr =
              HTML::TreeBuilder::XPath->new_from_content( $tr_item->as_HTML );
            my $td_list = [ $tr->findvalues("//td") ];

            #warn Dumper($td_list);
            die 'Não conseguiu encontrar as colunas com os dados no HTML'
              unless scalar( @{$td_list} ) ==
                  scalar( @{ $self->elements_list } );

            my $line_data = { mesh @{ $self->elements_list }, @{$td_list} };
            push @{$data}, $line_data;
            $tr->delete;
        }
        $tree->delete;
    }

    #warn Dumper($data);
    return scalar( @{$data} ) ? $data : undef;
}

1;

