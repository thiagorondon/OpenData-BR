
package OpenData::AZ::Box;

=head1 NAME

OpenData::AZ::Box - A role that defines a task in a data flow

=head1 SYNOPSIS

=cut

use Moose::Role;
use Scalar::Util qw/blessed reftype/;

use constant {
    SVALUE  => 'SVALUE',
    BLESSED => 'BLESSED',
};

has 'previous' => (
    is  => 'rw',
    isa => 'OpenData::AZ::Box',
    predicate => 'has_previous',
);

has '_buffer' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    clearer => '_clear_buffer',
    default => sub { return [] },
);

sub enqueue {
    my $self = shift;
    push @{ $self->_buffer }, @_;
}

sub dequeue {
    my $self = shift;
    local $, = ',';
    #print STDERR 'dequeuing (';
    #print STDERR @{ $self->_buffer };
    #print STDERR ")\n";
    return shift @{ $self->_buffer } unless wantarray;
    #print STDERR 'dequeuing [wantarray] (';
    #print STDERR @{ $self->_buffer };
    #print STDERR ")\n";
    my $b = $self->_buffer;
    $self->clear_queue;
    return @{ $b };
}

sub clear_queue {
    my $self = shift;
    $self->_buffer( [] );
}

sub get_input {
    my $self = shift;
    return unless $self->has_previous;
    $self->input( $self->previous->output );
}

sub input {
    my $self = shift;
    return unless @_;
    $self->enqueue( @_ );
}

sub output {
    my $self = shift;
    $self->get_input;
    return $self->_handle_item( scalar $self->dequeue ) unless wantarray;
    return $self->_handle_list( $self->dequeue );
}

requires 'process_item';

sub _handle_list {
    my $self   = shift;
    my @result = ();
    foreach my $item (@_) {
        push @result, $self->_handle_item($item);
    }
    return @result;
}

sub _handle_item {
    my ( $self, $item ) = @_;
    my $type = param_type($item);
    $self->confess( 'There is no handler for this parameter type!' )
        unless exists $self->_handlers->{$type};
    return $self->_handlers->{$type}->($self,$item);
}

sub param_type {
    my $p = shift;
    my $r = reftype($p);
    return SVALUE unless $r;
    return BLESSED if blessed($p);
    return $r;
}

has '_handlers' => (
    is => 'ro',
    isa => 'HashRef',
    default => sub {
        return {
            SVALUE  => \&_handle_svalue,
            SCALAR  => \&_handle_svalue,
            BLESSED => \&_handle_svalue,
            ARRAY => \&_handle_svalue,
            HASH => \&_handle_svalue,
            CODE => \&_handle_svalue,
        },
    },
);

sub _handle_svalue {
    my ($self, $item) = @_;
    return $self->process_item($item);
}

sub _handle_scalar {
    my ($self, $item) = @_;
    my $res = $self->process_item($$item);
    return \$res;
}

sub _handle_code {
    my ($self, $item) = @_;
    return $self->process_item($item->());
}

1;

__END__

=head1 AUTORES, LICENÇA e COPYRIGHT

Veja OpenData.pm

=cut

