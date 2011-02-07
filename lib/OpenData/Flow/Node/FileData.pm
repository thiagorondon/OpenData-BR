
package OpenData::Flow::Node::FileData;

use Moose;
use MooseX::Types::IO 'IO';

extends 'OpenData::Flow::Node::NOP';

has _handle => (
    is        => 'rw',
    isa       => 'IO',
    coerce    => 1,
    predicate => 'has_handle',
    clearer   => 'clear_handle',
);

has nochomp => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

sub _check_eof {
    my $self = shift;
    if ( $self->_handle->eof ) {
        $self->_handle->close;
        $self->clear_handle;
    }
}

override 'process_input' => sub {
    my $self = shift;

    until ( $self->has_handle ) {
        return unless $self->has_input;
        my $nextfile = $self->_dequeue_input;

        eval { $self->_handle($nextfile) };
        $self->confess($@) if $@;

        # check for EOF
        $self->_check_eof;
    }

    my $fh   = $self->_handle;
    my $item = <$fh>;
    chomp $item unless $self->nochomp;

    # check for EOF
    $self->_check_eof;

    # TODO some device to add multiple items (<infinity) to the output queue
    $self->_add_output($item);
};

1;

