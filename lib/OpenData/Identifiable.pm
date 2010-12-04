
package OpenData::Identifiable;

use Moose::Role;

has id => (
    is  => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub { 
        my $self = shift;
        defined($self->component_name) ? $self->component_name : undef }
);

has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { shift->id },
);

has description => ( is => 'ro', isa => 'Str', );

42;

