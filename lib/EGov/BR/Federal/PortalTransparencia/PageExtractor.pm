
package EGov::BR::Federal::PortalTransparencia::PageExtractor;

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

