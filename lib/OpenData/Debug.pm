
package OpenData::Debug;

use Moose::Role;

has is_debug => (
    traits => ['Bool'],
    is => 'rw',
    isa => 'Bool',
    default => 1,
    handles => {
        set_debug   => 'set',
        not_debug   => 'unset'
    }
);

sub debug {
    my ($self, @items) = @_;
    return unless $self->is_debug;
    print STDERR $_ . "\n" for (@items);
}

1;

