
package OpenData::Runtime;

use Moose;
use OpenData::Get;
use OpenData::Output;

with 'MooseX::Traits';
with 'OpenData::Debug';

extends 'OpenData::Config';

has '+_trait_namespace' => ( default => 'OpenData' );

has set_browser => (
    is => 'rw',
    isa => 'Str',
    default => 'Curl'
);

after set_browser => sub {
    my $self = shift;
    my $orig = shift;
    return if !$orig;
    $self->_get(OpenData::Get->with_traits($orig)->new)
};

has _get => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub { OpenData::Get->with_traits(shift->set_browser)->new }
);

sub BUILD {
    my $self = shift;
    $self->get_config;
}

sub get {
    my ($self, $url) = @_;
    my $http = $self->_get;
    $http->url($url);  
    return $http->get();
}

1;

