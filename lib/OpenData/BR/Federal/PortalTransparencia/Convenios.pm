
package OpenData::BR::Federal::PortalTransparencia::Convenios;

use Moose;

with 'OpenData::Debug';
with 'OpenData::BR::Federal::PortalTransparencia::Base';
with 'OpenData::Provider::Collection';

use Data::Dumper;
use List::MoreUtils qw/mesh/;
use HTML::TreeBuilder::XPath;

has '+id'          => ( default => 'convenios', );
has '+description' => ( default => 'Convênios', );

has '+mainURI' => (
    default => sub {
        join( '/', 'convenios', 'ConveniosListaGeral.asp?Ordem=-1' );
    },
);

has '+elements_list' => (
    default => sub {

        #return [ qw/uf municipio SIAFI situacao n_original objeto_do_convenio
        #orgao_superior concedente convenente valor_convenio valor_liberado
        #publicacao inicio_vigencia fim_vigencia valor_contrapartida
        #data_ultima_liberacao valor_ultima_liberacao/
        #];

        return [
            qw/numero numero_original uf objeto orgao_superior concedente
              convenente valor_conveniado/
        ];
    },
);

sub _extract {
    my $self = shift;
    my $page = $self->turn_page;
    return unless $page;    # empty if in last page

    my $url = $self->_make_page_url($page);
    my $raw = [];

    #warn 'url = '. $url;
    my $content = $self->get($url);
    $raw = [$content];

# inserir código de "click" aqui
# - findnode .../td/a
# - pega o valor do atributo href
# - faz o get
# - acrescenta o resultado no array ref $raw
#
#my $tree    = HTML::TreeBuilder::XPath->new_from_content($content);
#my $tr_list = $tree->findnodes('//div[@id="listagemConvenios"]/table/tbody/tr');

    #$self->debug( 'Página ' . $self->page . ' extraída' );
    return $raw;
}

sub _transform {
    my ( $self, $content ) = @_;

    my $data = [];
    foreach my $page ( @{$content} ) {
        my $tree = HTML::TreeBuilder::XPath->new_from_content($page);
        my $tr_list =
          $tree->findnodes('//div[@id="listagemConvenios"]/table/tbody/tr');

        die 'Não conseguiu encontrar as tabelas com os dados no HTML'
          unless scalar( @{$tr_list} );

        foreach my $tr_item ( @{$tr_list} ) {

            warn 'tr_item = ' . Dumper( $tr_item->as_HTML );
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

