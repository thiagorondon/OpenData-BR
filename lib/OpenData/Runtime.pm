
package OpenData::Runtime;

use Moose;
use OpenData::Get;
use utf8;

with 'MooseX::Traits';
with 'OpenData::Debug';

extends 'OpenData::Config';

has '+_trait_namespace' => ( default => 'OpenData' );

sub BUILD {
    my $self = shift;
    $self->get_config;
}

sub get {
    my ($self, $url) = @_;
    my $http = OpenData::Get->with_traits('Curl')
        ->new( url => $url );
    
    return $http->get();
}

1;

