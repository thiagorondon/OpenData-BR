
package OpenData::Provider;

use Carp;
use Moose::Role;

use OpenData::Provider::Collection;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has id => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { uc( shift->name ) },
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

    $coll->parent($self);

    my $colls = $self->collections;
    $colls->{ $coll->id } = $coll;
}

sub process {
    my ( $self, $coll ) = @_;

    croak qq{No such collection: }. $coll
      unless exists $self->colections->{$coll};

    my $coll_ref = $self->colections->{$coll};

    $coll_ref->extract;
    $coll_ref->transform;
    $coll_ref->load;
}

1;

