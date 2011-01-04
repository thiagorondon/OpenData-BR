
package OpenData::Extractor::HTTP;

use Moose;

with 'OpenData::Extractor';

use OpenData::Get;

has URL => ( is => 'ro', isa => 'Str', required => 1 );

has _get => (
    is      => 'rw',
    isa     => 'OpenData::Get',
    lazy    => 1,
    default => sub { OpenData::Get->new }
);

sub get {
    my ( $self, $url ) = @_;
    #warn 'url = '.$url;
    my $http = $self->_get;
    #$http->url($url);
    return $http->get($url);
}

sub extract {
    my $self = shift;
    return $self->get( $self->URL );
}

1;
