
package OpenData::Provider::Collection;

use Moose::Role;

use OpenData::Get;
use OpenData::Provider;

with 'OpenData::Debug';

has id => ( is => 'ro', isa => 'Str', required => 1, );

has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { ucfirst( shift->id ) },
);

has description => ( is => 'ro', isa => 'Str', );

has provider => ( is => 'rw', isa => 'OpenData::Provider', weak_ref => 1, );

##############################################################################

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
    my $http = $self->_get;
    $http->url($url);
    return $http->get();
}

##############################################################################

requires '_extract';

sub extract {
    my $self = shift;

    return $self->_extract;
}

sub extract_all {
    my $self = shift;

    my $queue = [];
    while ( my $raw = $self->extract ) {
        push @{$queue}, @{$raw};
    }

    return $queue;
}

##############################################################################

requires '_transform';

sub transform {
    my ( $self, $raw ) = @_;
    $self->confess('Cannot transform empty data') unless $raw;
    return $self->_transform($raw);
}

sub transform_all {
    my ( $self, $full_raw ) = @_;

    my $queue = [];
    foreach my $raw ( @{$full_raw} ) {
        my $data = $self->transform($raw);
        push @{$queue}, @{$data};

    }

    return $queue;
}

##############################################################################

requires '_load';

sub load {
    my ( $self, $data ) = @_;
    $self->confess('Cannot load empty data') unless $data;
    return unless $data;
    return $self->_load($data);
}

sub load_all {
    my ( $self, $full_data ) = @_;

    foreach my $data ( @{$full_data} ) {
        $self->load($data);
    }
}

42;

