
package BR::Federal::PortalTransparencia::Base;

use Moose::Role;

use HTML::TreeBuilder::XPath;
use URI;

sub _make_page_url {
    my ( $self, $numero ) = @_;
    my $u = URI->new( $self->mainURL );
    $u->query_form( Pagina => $numero );
    return $u->as_string;
}

sub _total_page {
    my $self = shift;
    my $html = $self->get( $self->mainURL );
    my $numero =
      HTML::TreeBuilder::XPath->new_from_content($html)
      ->findnodes('//p[@class="paginaAtual"]')->[0];

    die q{Não conseguiu fazer a paginação} unless $numero;

    my $total = $numero->as_text;
    $numero->delete;
    return $1 if $total =~ /\d\/(\d+)/;
}

has baseURL => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://www.portaltransparencia.gov.br/',
);

has mainURI => (
    is  => 'ro',
    isa => 'Str',
);

has mainURL => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        join( '/', $self->baseURL, $self->mainURI );
    },
);

has page => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => 1,
);

sub turn_page {
    my $self = shift;
    return unless $self->page < $self->last_page;
    return $self->page( $self->page + 1 );
}

has last_page => (
    is      => 'ro',
    isa     => 'Int',
    lazy    => 1,
    default => sub { shift->_total_page(); },
);

1;

