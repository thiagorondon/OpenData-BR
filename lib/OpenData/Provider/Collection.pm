
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
    lazy => 1,
    default => sub { ucfirst( shift->id ) },
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

requires '_extract_chunk';

sub extract_chunk {
    my $self = shift;

    return $self->_extract_chunk;
}

sub extract_all {
    my $self = shift;

    my $queue = [];
    while( my $raw = $self->extract_chunk ) {
        push @{ $queue }, @{ $raw };
    }

    return $queue;
}

##############################################################################

requires '_transform_chunk';

sub transform_chunk {
    my ($self, $raw) = @_;
    return unless $raw;
    return $self->_transform_chunk( $raw );
}

sub transform_all {
    my ($self,$full_raw) = @_;

    my $queue = [];
    foreach my $raw ( @{ $full_raw } ) {
        my $date = $self->transform_chunk( $raw );
        push @{ $queue }, @{ $data };

    }

    return $queue;
}

##############################################################################

requires '_load_chunk';

sub load_chunk {
    my ($self, $raw) = @_;
    return unless $raw;
    return $self->_load_chunk( $raw );
}

sub load_all {
    my ($self,$full_data) = @_;

    foreach my $data ( @{ $full_data } ) {
        $self->load_chunk( $data );
    }
}

42;

