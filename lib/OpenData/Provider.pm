
package OpenData::Provider;

use Carp;
use Moose::Role;

use OpenData::Provider::Collection;

has id => (
    is      => 'ro',
    isa     => 'Str',
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => 'Str',
    lazy => 1,
    default => sub { ucfirst( shift->id ) },
);

has description => (
    is  => 'ro',
    isa => 'Str',
);

has collections => (
    is  => 'ro',
    isa => 'HashRef[OpenData::Provider::Collection]',
);

has loader => (
    is => 'ro',
    isa => 'OpenData::Loader',
);

sub add_collection {
    my ($self, $coll ) = @_;

    $coll->provider($self);

    my $colls = $self->collections;
    $colls->{ $coll->id } = $coll;
}

sub collection {
    my ( $self, $coll ) = @_;

    croak qq{No such collection: }. $coll
      unless exists $self->collections->{$coll};

    return $self->collections->{$coll};
}

sub process {
    my ( $self, $coll ) = @_;

    my $coll_ref = $self->collection($coll);

    while( my $raw = $coll_ref->extract_chunk ) {
        my $data = $coll_ref->transform( $raw );
        $coll_ref->load( $data );
    }
}

42;

