
package OpenData::BR::Federal::PortalTransparencia::Page;

use Moose::Role;
use HTML::TreeBuilder::XPath;
use URI;

sub _page {
    my ( $self, $url, $numero ) = @_;
    my $u = URI->new($url);
    $u->query_form( Pagina => $numero );
    return $u->as_string;
}

sub _total_page {
    my ( $self, $html ) = @_;
    my $numero =
      HTML::TreeBuilder::XPath->new_from_content($html)
      ->findnodes('//p[@class="paginaAtual"]')->[0];
    if ($numero) {
        my $total = $numero->as_text;
        $numero->delete;
        return $1 if $total =~ /\d\/(\d+)/;
    }
    else {
        die "Não conseguiu fazer a paginação";
    }
}

1;

