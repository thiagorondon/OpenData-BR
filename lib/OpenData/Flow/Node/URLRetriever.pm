
package OpenData::Flow::Node::URLRetriever;

use Moose;
with 'OpenData::Log';
extends 'OpenData::Flow::Node';

use OpenData::Get;

has _get => (
    is      => 'rw',
    isa     => 'OpenData::Get',
    lazy    => 1,
    default => sub { OpenData::Get->new }
);

has baseurl => (
    is        => 'ro',
    isa       => 'Str',
    predicate => 'has_baseurl',
);

has '+process_item' => (
    default => sub {
        return sub {
            my ( $self, $item ) = @_;

            #warn 'process_item:: item = '.$item;
            my $url =
              $self->has_baseurl
              ? URI->new_abs( $item, $self->baseurl )->as_string
              : $item;

            $self->debug("process_item:: url = $url");
            return $self->_get->get($url);
          }
    },
);

1;

