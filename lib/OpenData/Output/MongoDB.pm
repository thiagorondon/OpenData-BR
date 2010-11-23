

package OpenData::Output::MongoDB;

use Moose::Role;
use MongoDB;

has host => (
    is      => 'rw',
    isa     => 'Str',
    default => 'localhost'
);

has database => (
    is      => 'rw',
    isa     => 'Str',
    default => 'opendata'
);

has collection => (
    is      => 'rw',
    isa     => 'Str',
    default => 'br'
);


has _collection => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $conn = MongoDB::Connection->new(host => $self->host);
        my $database = $conn->get_database($self->database);
        my $collection = $database->get_collection($self->collection);
        return $collection;
    }
);

sub add {
    my ($self, $object) = @_;

    return $self->_collection->insert($object);

}

1;

