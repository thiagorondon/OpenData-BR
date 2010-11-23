

package OpenData::Output::KiokuDB::MongoDB;

use Moose::Role;
use KiokuDB;
use KiokuDB::Backend::MongoDB;

has host => (
    is      => 'ro',
    isa     => 'Str',
    default => 'localhost'
);

has database => (
    is      => 'ro',
    isa     => 'Str',
    default => 'opendata'
);

has collection => (
    is      => 'ro',
    isa     => 'Str',
    default => 'br'
);


has _connect => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $conn = MongoDB::Connection->new(host => $self->host);
        my $mongodb = $conn->get_databases($self->database);
        my $collection = $mongodb->get_collection($self->collection);
        my $mongo = KiokuDB::Backend::MongoDB
            ->new('collection' => $collection);
        warn $mongo;
        return KiokuDB->new( backend => $mongo );
    }
);

sub add {
    my ($self, $object) = @_;

    my $mongo = $self->_connect;
    my $scope = $mongo->new_scope;
    my $uuid = $mongo->store(\$object);
    return $uuid;
}

1;

