
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

has do_slurp => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has _get_item => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        #use Data::Dumper; print STDERR Dumper($self);

        return sub {
            #use Data::Dumper; print STDERR 'slurpy ' .Dumper($self);
            my $fh   = $self->_handle;
            my @slurp = <$fh>;
            chomp @slurp unless $self->nochomp;
            #use Data::Dumper; print STDERR 'slurpy ' .Dumper([@slurp]);
            return [ @slurp ];
          }
          if $self->do_slurp;

        # not a slurp, rather line by line
        if ( $self->nochomp ) {
            return sub {
                #use Data::Dumper; print STDERR 'nochompy ' .Dumper($self);
                my $fh = $self->_handle;
                my $item = <$fh>;
                return $item;
            };
        }
        else {
            return sub {
                #use Data::Dumper; print STDERR 'chompy ' .Dumper($self);
                my $fh = $self->_handle;
                my $item = <$fh>;
                chomp $item;
                return $item;
            };
        }
    },
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

    my @item = ( $self->_get_item->() );
    #use Data::Dumper; print STDERR 'items '.Dumper( [ @item ] );

    # check for EOF
    $self->_check_eof;

    # TODO some device to add multiple items (<infinity) to the output queue
    $self->_add_output( $self->_handle_list(@item));
};

1;

