package EGov::BR::Federal::PortalTransparencia::Util::Paginar;

use strict;
use warnings;

use Moose;
extends 'DataFlow::Proc::MultiPageURLGenerator';

use DataFlow::Util::HTTPGet;
use HTML::TreeBuilder::XPath;
use URI;

has '+produce_last_page' => (
    default => sub {
        return sub {
            my $url = shift;

            my $get  = DataFlow::Util::HTTPGet->new;
            my $html = $get->get($url);

            my $texto =
              HTML::TreeBuilder::XPath->new_from_content($html)
              ->findvalue('//p[@class="paginaAtual"]');
            die q{Não conseguiu determinar a última página}
              unless $texto;
            return $1 if $texto =~ /\d\/(\d+)/;
          }
    },
);

has '+make_page_url' => (
    default => sub {
        return sub {
            my ( $self, $url, $page ) = @_;

            my $u = URI->new($url);
            $u->query_form( $u->query_form, Pagina => $page );
            return $u->as_string;
          }
    },
);

1;

