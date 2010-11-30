
package OpenData::BR::Federal::PortalTransparencia::CEIS;

use Moose;

use Data::Dumper;
use List::MoreUtils qw/mesh/;

with 'OpenData::Debug';
with 'OpenData::BR::Federal::PortalTransparencia::Base';
with 'OpenData::Provider::Collection';

use HTML::TreeBuilder::XPath;

has '+id'          => ( default => 'ceis', );
has '+name'        => ( default => 'CEIS', );
has '+description' => ( default => 'EMPRESAS SANCIONADAS', );

has '+mainURI' => (
    default => sub {
        my $base = shift->baseURL || '';
        join( '/', $base, 'ceis', 'EmpresasSancionadas.asp?paramEmpresa=0' );
    },
);

has '+elements_list' => (
    default => sub {
        [
            q{cpfcnpj},    q{nome},
            q{tipo},       q{data_inicial},
            q{data_final}, q{orgao_sancionador},
            q{uf},         q{fonte},
            q{fonte_data},
        ];
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
          unless scalar( @{$td_list} ) == scalar( @{ $self->elements_list });

        my $line_data = { mesh @{ $self->elements_list }, @{$td_list} };
        push @{$data}, $line_data;
        $tr->delete;
    }
    $tree->delete;

    #warn Dumper($data);
    return $data ? $data : undef;
}

1;

