
package OpenData::Flow::Node;

use Moose;
use Scalar::Util qw/blessed reftype/;

=head1 NAME

OpenData::Flow::Node - A Moose class that defines a task in a data flow

=head1 SYNOPSIS

    use OpenData::Flow::Node;

    my $uc = OpenData::Flow::Node->new(
        process_item => sub {
            shift; return uc(shift);
        }
    );

    my @res = $uc->process( qw/god save the queen/ );
    # @res == qw/GOD SAVE THE QUEEN/

    # or, in two steps:
    $uc->input( qw/dont panic/ );
    my @cool = $uc->output;
    # @cool == qw/DONT PANIC/

Or

    my $ucd = UC->new(
        process_into => 1,
        process_item => sub {
            shift; return uc(shift);
        }
    );

    $ucd->input( [ qw/aaa bbb ccc/ ] );
    $item = $ucd->output;
    # $item == [ 'AAA', 'BBB', 'CCC' ]
    
    $ucd->input( { a => 'aaa', b => 'bbb } );
    $item = $ucd->output;
    # $item == { a => 'AAA', b => 'BBB' }

=head1 DESCRIPTION

This is a L<Moose> based class that provides the idea of a step in a data-flow.
It attemps to be as generic and unassuming as possible, in order to provide
flexibility for implementors to make their own boxes as they see fit.

An object of the type C<OpenData::Flow::Node> does three things:
accepts some data as input,
processes that data,
provides the transformed data as output.

The methods C<input> and C<output> provide the obvious functionality,
while attempting to preserve the input data structure.
The convenience method C<process()> will pump its parameters
into C<< $self->input() >> and immediately
return the result of C<< $self->output() >>.

A box will only be useful if, naturally,
it performs some sort of transformation or processing on the input data.
Thus, objects of the type C<OpenData::Flow::Node> B<must> provide
the code reference named C<process_item>.
This method will be called with just one parameter at a time,
which will correspond one single input item.

Unless told differently (see the C<process_into> option below),
C<OpenData::Flow::Node> will treat as an individual item anything that is:
a scalar, a blessed object, and a reference (of any kind).
And, it will iterate over anything that is either
an array or hash (treated like an array, as described above).

However, it might be convenient in many cases to have things work in a smarter
way. If the input is an array reference, one might expect that every element
in the referenced array should be processed. Or, that every value in a hash
reference should be processed. For cases like that, C<OpenData::Flow::Node>
provides a simple de-referencing mechanism.

=head2 INPUT

The input is provided through the method C<< input() >>, which will gladly
accept anything passed as parameter. However, it must be noticed that it
will not be able to make a distinction between arrays and hashes. Both forms
below will render the exact same results:

    $box->input( qw/all the simple things/ );
    $box->input( all => the, simple => 'things' );

If you do want to handle arrays and hashes differently, we strongly suggest
that you use references:

    $box->input( [ qw/all the simple things/ ] );
    $box->input( { all => the, simple => 'things' } );

And, in the C<process_item>

    my $box = OpenData::AZ:Node->new(
        process_item => sub {
            my ($self,$item) = @_;
            if( ref($item) eq 'ARRAY' ) {
                my @a = @{ $item };
                # ... do something with array @a
            }
            elsif( ref($item) eq 'HASH' ) {
                my %hash = %{ $item };
                # ... handle hash differently
            }
            ...
        }
    );

=head2 PROCESS

The processing of the data is performed by the sub referenced by the
C<< process_item >> attribute. This attribute is B<required> by
C<< OpenData::AZ:Node >>.

=head3 Calling Convention

The code referenced by C<process_item> will be called with two arguments: a
reference to the C<< OpenData::AZ:Node >> object, and one single item from
the input queue, be it a simple scalar, or any type of reference. The code
below shows a typical implementation:

    my $box = OpenData::Flow::Node->new(
        process_item => sub {
            my ($self,$item) = @_;
            # do something with $item
            return $processed_item;
        }
    );

=head3 Inheritance

When inheriting from C<< OpenData::AZ:Node >>, some classes may provide a
default code for C<process_item>. For instance:

    package UCNode;

    use Moose;
    extends 'OpenData::Flow::Node';

    has '+process_item' => (
        default => sub {
            return sub {
                shift; return uc(shift);
            }
        },
    );

Notice that the enclosing C<sub> B<< is mandatory >> in this case. The reason
is that the outter C<sub> is responsible for providing a default value to
C<process_item> and is run only once by C<Moose>, while the inner C<sub>
is the actual value of the code reference C<process_item>, and will be invoked
every time a data item needs to be processed. 

=head3 Dereferencing

If you set the attribute C<process_into> as C<true>, then the box will
treat references differently.
It will process the referenced objects, rather than the actual reference.
It will work as follows:

    $scalar = 'some text';
    $ucd->input( \$scalar );
    $res = $ucd->output;
    print ${ $res };     # 'SOME TEXT'

    $aref = [ qw/this is a test/ ];
    $ucd->input( $aref );
    $res = $ucd->output;
    print Dumper($res);  # $VAR1 = [ 'THIS', 'IS', 'A', 'TEST' ]

    $href = { apple => 'red', orange => 'orange', pineapple => 'yellow' };
    $ucd->input( $href );
    $res = $ucd->output;
    print Dumper($res);  # $VAR1 = {
                               apple     => 'RED',
                               orange    => 'ORANGE',
                               pineapple => 'YELLOW',
                           }

    $cref = sub { return 'a dozen dirty pirates' };
    $ucd->input( $cref );
    $res = $ucd->output;
    print $res;          # 'A DOZEN DIRTY PIRATES'

Notice that, except for the code reference, for all others C<Node> will
preserve the original structure.

=head2 OUTPUT

The output is provided by the method C<output>. If called in scalar context
it will return one processed item from the box. If called in list context it
will return all the elements in the queue.

=head1 ATTRIBUTES

=head2 process_into

A boolean attribute that signals whether references should be dereferenced or
not.

=head2 process_item

A code reference that is the actual work horse for this class. It is a
mandatory attribute, and must follow the calling conventions described above.

=cut

has deref => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has process_into => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has process_item => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

=head1 METHODS

=head2 input

Provide input data for the box.

=cut

sub input {
    my $self = shift;

    #local $,=','; print STDERR "input = ", @_, "\n";
    return unless @_;
    $self->_enqueue_input(@_);
}

=head2 output

Fetch data from the box.

=cut

sub output {
    my $self = shift;

    return unless $self->has_input;
    #use Data::Dumper;
    #print STDERR "output(): self = " .Dumper($self);
    return $self->_handle_list( $self->_dequeue_input ) if wantarray;

    #print STDERR "====> wantarray! NOT!\n";
    return $self->_handle_item( scalar $self->_dequeue_input );
}

=head2 flush

Flushes this node's queues

=cut

sub flush {
    my $self = shift;
    while( $self->output ) { };
}

=head2 has_input

Returns true if there is data in the input queue, false otherwise.

=cut

sub has_input {
    my $self = shift;
    return 0 < scalar @{ $self->_input_queue };
}

=head2 has_output

Returns true if there is data in the output queue, false otherwise.

=cut

sub has_output {
    my $self = shift;
    return 0 < scalar @{ $self->_output_queue };
}

=head2 has_queued_data

Returns true if there is data in any of this box queues, false otherwise.

=cut

sub has_queued_data {
    my $self = shift;
    return ($self->has_input || $self->has_output);
}

=head2 process

Convenience method to provide input and immediately get the output.

=cut

sub process {
    my $self = shift;
    return unless @_;
    $self->input(@_);
    return $self->output;
}

##############################################################################
# box input queue

has '_input_queue' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { return [] },
);

sub _enqueue_input {
    my $self = shift;
    push @{ $self->_input_queue }, @_;
}

sub _dequeue_input {
    my $self = shift;
    #warn 'dequeue';
    return scalar shift @{ $self->_input_queue } unless wantarray;
    #warn 'dequeue wants array';
    my $b = $self->_input_queue;
    $self->_clear_input_queue;
    #local $,= ','; warn 'dequeue returns ',@{$b};
    return @{$b};
}

sub _clear_input_queue {
    my $self = shift;
    $self->_input_queue( [] );
}

##############################################################################
# box output queue

has '_output_queue' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { return [] },
);

sub _enqueue_output {
    my $self = shift;
    push @{ $self->_output_queue }, @_;
}

sub _dequeue_output {
    my $self = shift;
    #warn 'dequeue';
    return scalar shift @{ $self->_output_queue } unless wantarray;
    #warn 'dequeue wants array';
    my $b = $self->_output_queue;
    $self->_clear_output_queue;
    #local $,= ','; warn 'dequeue returns ',@{$b};
    return @{$b};
}

sub _clear_output_queue {
    my $self = shift;
    $self->_input_queue( [] );
}

##############################################################################

sub _process_input {
}

##############################################################################
# code to handle different types of input
#   ex: array-refs, hash-refs, code-refs, etc...

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
    my $type = _param_type($item);
    $self->confess('There is no handler for this parameter type!')
      unless exists $self->_handlers->{$type};
    return $self->_handlers->{$type}->( $self, $item );
}

use constant {
    SVALUE  => 'SVALUE',
    BLESSED => 'BLESSED',
};

sub _param_type {
    my $p = shift;
    my $r = reftype($p);
    return SVALUE unless $r;
    return BLESSED if blessed($p);
    return $r;
}

has '_handlers' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $me = shift;
        return {
            SVALUE  => \&_handle_svalue,
            BLESSED => \&_handle_svalue,
            SCALAR  => $me->process_into ? \&_handle_scalar : \&_handle_svalue,
            ARRAY   => $me->process_into ? \&_handle_array : \&_handle_svalue,
            HASH    => $me->process_into ? \&_handle_hash : \&_handle_svalue,
            CODE    => $me->process_into ? \&_handle_code : \&_handle_svalue,
          },
          ;
    },
);

sub _handle_svalue {
    my ( $self, $item ) = @_;
    return $self->process_item->( $self, $item );
}

sub _handle_scalar {
    my ( $self, $item ) = @_;
    my $r = $self->process_item->( $self, $$item );
    return $self->deref ? $r : \$r;
}

sub _handle_array {
    my ( $self, $item ) = @_;
    my @r = map { $self->process_item->( $self, $_ ) } @{$item};
    return $self->deref ? @r : [ @r ];
}

sub _handle_hash {
    my ( $self, $item ) = @_;
    my %r = map { $_ => $self->process_item->( $self, $item->{$_} ) }
          keys %{$item};
    return $self->deref ? %r : { %r };
}

sub _handle_code {
    my ( $self, $item ) = @_;
    return $self->process_item->( $self, $item->() );
}

1;

