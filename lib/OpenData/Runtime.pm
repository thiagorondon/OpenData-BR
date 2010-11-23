
package OpenData::Runtime;

use Moose;
use OpenData::Get;
use OpenData::Output;

with 'MooseX::Traits';
with 'OpenData::Debug';

extends 'OpenData::Config';

has '+_trait_namespace' => ( default => 'OpenData' );

has set_type => (
    is => 'ro',
    isa => 'Str',
    default => 'Curl'
);

has _get => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub { OpenData::Get->with_traits(shift->set_type)->new }
);

has set_output => (
    is => 'ro',
    isa => 'Str',
    default => 'Dumper'
);

has _output => (
    is  => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub { OpenData::Output->with_traits(shift->set_output)->new }
);

sub BUILD {
    my $self = shift;
    $self->get_config;
}

sub transform {
    my $self = shift;
    my $data = shift;

    my $output = $self->_output;
    return $output->transform($data);
}

sub get {
    my ($self, $url) = @_;
    my $http = $self->_get;
    $http->url($url);  
    return $http->get();
}

1;

