
package OpenData::Provider::Collection;

use Moose::Role;

use OpenData::Provider;
use OpenData::Utils;

with 'OpenData::Log';
with 'OpenData::Identifiable' => { -excludes => 'id' };

has id => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        my $self = shift;
        defined( $self->component_name )
          ? OpenData::Utils::class2suffix( $self->component_name )
          : undef;
    }
);

has provider => (
    is       => 'rw',
    isa      => 'OpenData::Provider',
    weak_ref => 1,
);

has extractor => (
    is       => 'ro',
    isa      => 'OpenData::Extractor',
    required => 1,
);

has transformer => (
    is       => 'ro',
    isa      => 'OpenData::Transformer',
    required => 1,
);

has loader => (
    is       => 'ro',
    isa      => 'OpenData::Loader',
    required => 1,
    lazy     => 1,
    default  => sub {
        shift->provider->loader;
    },
);

sub extract {
    my $self = shift;

    return $self->extractor->extract;
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

sub transform {
    my ( $self, $raw ) = @_;
    $self->confess('Cannot transform empty data') unless $raw;
    return $self->transformer->transform($raw);
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

sub load {
    my ( $self, $data ) = @_;
    $self->confess('Cannot load empty data') unless $data;
    return unless $data;
    return $self->loader->load($data);
}

sub load_all {
    my ( $self, $full_data ) = @_;

    foreach my $data ( @{$full_data} ) {
        $self->load($data);
    }
}

42;

