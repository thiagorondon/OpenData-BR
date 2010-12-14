
package OpenData::AZ::Box;

use Moose;
use Scalar::Util qw/blessed reftype/;

=head1 NAME

OpenData::AZ::Box - A Moose class that defines a task in a data flow

=head1 SYNOPSIS

    use OpenData::AZ::Box;

    my $uc = OpenData::AZ::Box->new(
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
        deref => 1,
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

This is a L<Moose> based class that provides the idea of a step in a
data-flow.
It attemps to be as generic and unassuming as possible, in order to provide
flexibility for implementors to make their own boxes as they see fit.

An object of the type C<OpenData::AZ::Box> does three things: accepts some data as input, processes that data, provides the transformed data as output.

The methods C<input> and C<output> provide the obvious functionality, while
attempting to preserve the input data structure. The convenience method
C<process()> will pump its parameters into C<< $self->input() >> and immediately
return the result of C<< $self->output() >>.

A box will only be useful if, naturally, it performs some sort of
transformation or processing on the input data.  Thus, objects of the type
C<OpenData::AZ::Box> B<must> pass the code reference name C<process_item>.
This method will be called with just one parameter at a time, which will
correspond one single input item.

Unless told differently (see the C<deref> option below), C<OpenData::AZ::Box>
will treat as an individual item anything that is: a scalar, a blessed object,
and a reference (of any kind). And, it will iterate over anything that is
either an array or hash (treated like an array, as described above).

However, it might be convenient in many cases to have things work in a smarter
way. If the input is an array reference, one might expect that every element
in the referenced array should be processed. Or, that every value in a hash
reference should be processed. For cases like that, C<OpenData::AZ::Box>
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

    my $box = OpenData::AZ:Box->new(
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
C<< OpenData::AZ:Box >>.

=head3 Calling Convention

The code referenced by C<process_item> will be called with two arguments: a
reference to the C<< OpenData::AZ:Box >> object, and one single item from
the input queue, be it a simple scalar, or any type of reference. The code
below shows a typical implementation:

    my $box = OpenData::AZ::Box->new(
        process_item => sub {
            my ($self,$item) = @_;
            # do something with $item
            return $processed_item;
        }
    );

=head3 Inheritance

When inheriting from C<< OpenData::AZ:Box >>, some classes may provide a
default code for C<process_item>. For instance:

    package UCBox;

    use Moose;
    extends 'OpenData::AZ::Box';

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

If you set the attribute C< deref > as C<true>, then references will be
dereferenced as follows:

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

Notice that, except for the code reference, for all others C<Box> will
preserve the original structure. Maybe "deref" is not a good name for this.

=head2 OUTPUT

The output is provided by the method C<output>. If called in scalar context
it will return one processed item from the box. If called in list context it
will return all the elements in the queue.

=head1 ATTRIBUTES

=head2 deref

A boolean attribute that signas whether references should be dereferenced or
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

has process_item => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

=head1 METHODS

=cut

##############################################################################
# box queue

has '_queue' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { return [] },
    predicate => 'has_queue',
);

=head2 enqueue

Insert elements into this box' queue.

=cut

sub enqueue {
    my $self = shift;
    push @{ $self->_queue }, @_;
}

=head2 dequeue

Returns element(s) from the box queue. If called in scalar context will return
one element from the queue. If called in list context, will return all the
elements currently in the queue.

=cut

sub dequeue {
    my $self = shift;
    #warn 'dequeue';
    return scalar shift @{ $self->_queue } unless wantarray;
    #warn 'dequeue wants array';
    my $b = $self->_queue;
    $self->clear_queue;
    #local $,= ','; warn 'dequeue returns ',@{$b};
    return @{$b};
}

=head2 clear_queue

Reset the queue.

=cut

sub clear_queue {
    my $self = shift;
    $self->_queue( [] );
}

##############################################################################
# input/ouput methods

=head2 input

Provide input data for the box.

=cut

sub input {
    my $self = shift;

    #local $,=','; print STDERR "input = ", @_, "\n";
    return unless @_;
    $self->enqueue(@_);
}

=head2 output

Fetch data from the box.

=cut

sub output {
    my $self = shift;

    #use Data::Dumper;
    #print STDERR "output(): self = " .Dumper($self);
    return $self->_handle_list( $self->dequeue ) if wantarray;

    #print STDERR "====> wantarray! NOT!\n";
    return $self->_handle_item( scalar $self->dequeue );
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
        my $self = shift;
        return {
            SVALUE  => \&_handle_svalue,
            BLESSED => \&_handle_svalue,
            SCALAR  => $self->deref ? \&_handle_scalar : \&_handle_svalue,
            ARRAY   => $self->deref ? \&_handle_array : \&_handle_svalue,
            HASH    => $self->deref ? \&_handle_hash : \&_handle_svalue,
            CODE    => $self->deref ? \&_handle_code : \&_handle_svalue,
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
    return $self->process_item->( $self, $$item );
}

sub _handle_array {
    my ( $self, $item ) = @_;
    return [ map { $self->process_item->( $self, $_ ) } @{$item} ];
}

sub _handle_hash {
    my ( $self, $item ) = @_;
    return { map { $_ => $self->process_item->( $self, $item->{$_} ) }
          keys %{$item} };
}

sub _handle_code {
    my ( $self, $item ) = @_;
    return $self->process_item->( $self, $item->() );
}

1;

