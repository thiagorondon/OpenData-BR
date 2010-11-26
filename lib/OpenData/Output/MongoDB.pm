
package OpenData::Output::MongoDB;

use Moose::Role;
use MongoDB;
use DateTime;

has host => (
    is      => 'ro',
    isa     => 'Str',
    default => 'localhost'
);

has database => (
    is      => 'rw',
    isa     => 'Str',
    default => 'opendata'
);

after database => sub {
    my $self = shift;
    my $orig = shift;
    return if !$orig;
    $self->mongodb->get_database($orig);
};

has collection => (
    is      => 'rw',
    isa     => 'Str',
    default => 'br'
);

after collection => sub {
    my $self = shift;
    my $orig = shift;
    return if !$orig;
    $self->mongodb->get_collection($orig);
};

has mongodb => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $conn = MongoDB::Connection->new(host => $self->host);
        my $database = $conn->get_database($self->database);
        return $database->get_collection($self->collection);
    }
);

has brother => (
    is => 'rw',
    isa => 'Str',
    lazy => 1,
    default => sub {
        my $user = $ENV{'USER'} || '';
        my $host = $ENV{'HOSTNAME'} || '';
        return join('@', $user, $host) }
);

sub add {
    my ($self, $object) = @_;

    return $self->mongodb->insert(
        { "created" => DateTime->now->epoch,
          "brother" => $self->brother,
          "row" => $object });
}

1;

