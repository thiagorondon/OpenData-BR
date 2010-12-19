
package OpenData::Flow::Node::URLRetriever;

use Moose;
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
            my ( $self, $url ) = @_;
            $url = URI->new_abs( $url, $self->baseurl )->as_string
              if $self->has_baseurl;

            #warn 'process_item:: url = '.$url;
            return $self->_get->get($url);
          }
    },
);

#before 'output' => sub {
#    use Data::Dumper;
#    warn Dumper(shift);
#    local $, = q{ || };
#    warn @_;
#};

1;

