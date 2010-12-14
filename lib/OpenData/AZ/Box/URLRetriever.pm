
package OpenData::AZ::Box::URLRetriever;

use Moose;
extends 'OpenData::AZ::Box';

use OpenData::Get;

has set_browser => ( is => 'rw', isa => 'Str', default => 'Mechanize' );

after set_browser => sub {
    my $self = shift;
    my $orig = shift;
    return if !$orig;
    $self->_get( OpenData::Get->with_traits($orig)->new );
};

has _get => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub { OpenData::Get->with_traits( shift->set_browser )->new }
);

sub get {
    my ( $self, $url ) = @_;

    #warn 'url = '.$url;
    my $http = $self->_get;
    $http->url($url);
    return $http->get();
}

has baseurl => (
    is => 'ro',
    isa => 'Str',
    predicate => 'has_baseurl',
);

has '+process_item' => (
    default => sub {
        return sub {
            my ( $self, $url ) = @_;
            return unless $url;
            $url = URI->new_abs( $url, $self->baseurl )->as_string
                if $self->has_baseurl;
            #warn 'process_item:: url = '.$url;
            return $self->get($url);
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

