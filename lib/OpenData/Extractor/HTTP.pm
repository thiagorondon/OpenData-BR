
package OpenData::Extractor::HTTP;

use Moose;

with 'OpenData::Extractor';

use OpenData::Get;

has URL => ( is => 'ro', isa => 'Str', required => 1 );

has set_browser => ( is => 'rw', isa => 'Str', default => 'Curl' );

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

sub extract {
}

1;
