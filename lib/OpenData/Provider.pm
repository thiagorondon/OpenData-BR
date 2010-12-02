
package OpenData::Provider;

use Carp;
use Moose::Role;

with 'OpenData::Identifiable';

use OpenData::Provider::Collection;

has collections => (
    is      => 'ro',
    isa     => 'HashRef[OpenData::Provider::Collection]',
    lazy    => 1,
    default => sub { return {}; },
);

has loader => (
    is  => 'ro',
    isa => 'Object',

    #isa => 'OpenData::Loader',
);

sub add_collection {
    my ( $self, $coll ) = @_;

    $coll->provider($self);

    my $colls = $self->collections;

    $self->confess('Please, declare a collection ID') unless $coll->id;

    $self->confess(
        'A collection with ID (' . $coll->id . ') is already registered!' )
      if exists $colls->{ $coll->id };
    $colls->{ $coll->id } = $coll;
}

sub collection {
    my ( $self, $coll ) = @_;

    croak qq{No such collection: } . $coll
      unless exists $self->collections->{$coll};

    return $self->collections->{$coll};
}

sub process {
    my ( $self, $coll ) = @_;

    my $coll_ref = $self->collection($coll);

    while ( my $raw = $coll_ref->extract ) {
        my $data = $coll_ref->transform($raw);
        $coll_ref->load($data);
    }
}

42;

