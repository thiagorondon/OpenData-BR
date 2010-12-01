
package OpenData::Identifiable;

use Moose::Role;

has id => (
    is  => 'ro',
    isa => 'Str',
);

has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { ucfirst( shift->id ) },
);

has description => ( is => 'ro', isa => 'Str', );

42;

