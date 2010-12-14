
package Item;

use Moose;
use List::MoreUtils qw/mesh/;

with 'OpenData::Provider::Collection::Item';

my @items = (qw/cpfcnpj nome tipo data_inicial data_final orgao_sancionador uf fonte fonte_data/);

for my $obj (@items) {
    has $obj => ( is => 'ro', isa => 'Str', writer => "_$obj" );
}

sub elements_list { [ @items ]; }

sub new_from_array {
    my $pkg = shift;
    my $data = shift || '';

    die unless $pkg eq __PACKAGE__;

    no warnings;
    my @data = map { $_ =~ s/^\s*//; $_ =~ s/\s*$//; $_ } @{$data};
    my $item = __PACKAGE__->new( { mesh @{ elements_list() }, @data } );

    $item->_uf( uc( $item->uf ) );

    return $item;
}

1;

package Transformer;

use Moose;
extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;

    my $item = Item->new_from_array($data);
    return $item;
}

1;

package Extractor;

use Moose;
extends 'OpenData::Extractor::HTTP';

use URI;
use HTML::TreeBuilder::XPath;

has baseURL => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://www.portaltransparencia.gov.br',
);

has '+URL' => (
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $base = $self->baseURL || '';
        my $main = $self->mainURI || '';
        return $base . '/' . $main;
    },
);

has mainURI => ( is => 'ro', isa => 'Str', required => 1, );

sub _make_page_url {
    my ( $self, $numero ) = @_;
    my $u = URI->new( $self->URL );
    $u->query_form( Pagina => $numero );
    return $u->as_string;
}

sub _total_page {
    my $self = shift;
    my $html = $self->get( $self->URL );
    my $numero =
      HTML::TreeBuilder::XPath->new_from_content($html)
      ->findnodes('//p[@class="paginaAtual"]')->[0];

    die q{Não conseguiu fazer a paginação} unless $numero;

    my $total = $numero->as_text;
    $numero->delete;
    return $1 if $total =~ /\d\/(\d+)/;
}

has page => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => 0,
);

before 'page' => sub {
    my ( $self, $num ) = @_;
    if ($num) {
        $self->confess( 'Invalid page ('
              . $num
              . '), must be between 0 < x <= last page ('
              . $self->last_page
              . ')' )
          unless 0 < +$num && +$num <= $self->last_page;
    }
};

sub turn_page {
    my $self = shift;
    return unless $self->page < $self->last_page;
    return $self->page( $self->page + 1 );
}

has last_page => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    builder => '_total_page',
);

##############################################################################

sub extract {
    my $self = shift;
    my $page = $self->turn_page;
    return unless $page;    # empty if in last page

    my $url = $self->_make_page_url($page);

    #warn 'url = '. $url;
    my $content = $self->get($url);

    #$self->debug( 'Página ' . $self->page . ' extraída' );
    return [$content];
}

1;

package main;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use strict;
use warnings;

use OpenData::Simple;
use OpenData::Array;

my $opendata = provider {
    
    name => 'PortalTransparencia',
    description => 'Portal da Transparencia',
    url => 'http://portaltransparencia.gov.br',
    
    default_loader => 'Dumper',
    default_extract => 'HTTP',

    collections => [ {
        id => 'CEIS',
        extractor =>  
             Extractor->new( 
                mainURI => 'ceis/EmpresasSancionadas.asp?paramEmpresa=0'
        ) ,

        transformer => Transformer->new,
        loader => OpenData::Array->new_with_traits( traits => 'Dumper' )
    } ]

};

$opendata->process('CEIS');





