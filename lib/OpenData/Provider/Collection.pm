
package OpenData::Provider::Collection;

use Moose::Role;

use OpenData::Provider;

has id => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has name => (
    is  => 'ro',
    isa => 'Str',
);

has description => (
    is  => 'ro',
    isa => 'Str',
);

has provider => (
    is       => 'rw',
    isa      => 'OpenData::Provider',
    weak_ref => 1,
);

##############################################################################

has _raw_data => ( is => 'rw' );

requires '_extract';

sub extract {
    my $self = shift;
    $self->_raw_data( $self->_extract );
}

has _data => ( is => 'rw', );

requires '_transform';

sub transform {
    my $self = shift;
    $self->_data( $self->_transform );
}

requires '_load';

#sub _load {
#    my $self = shift;
#
#    my $loader = $self->provider->loader;
#    $loader->load( $self->_data );
#}

1;

