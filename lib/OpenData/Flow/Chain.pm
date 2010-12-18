
package OpenData::Flow::Chain;

use Moose;
extends 'OpenData::Flow::Node';

use OpenData::Flow::Node;
use List::Util qw/reduce/;

has chain => (
    is       => 'ro',
    isa      => 'ArrayRef[OpenData::Flow::Node]',
    required => 1,
);

has '+process_item' => ( default => sub { return sub { } },);

sub input {
    my $self = shift;
    $self->chain->[0]->input(@_);
}

sub output {
    my $self = shift;
    return unless $self->has_input;

    #use Data::Dumper;
    #warn 'chainbox :: chain = '.Dumper($self->chain);
    #local $, = "\n";
    #warn 'chainbox :: chain queues = ', map { Dumper($_->_queue) } @{ $self->chain };
    my $n = @{ $self->chain };
    $self->confess('Chain has no nodes, cannot process_item()') if $n == 0;

    my $first = $self->chain->[0];
    return $first->output if $n == 1;

    my $last = reduce { $b->input( $a->output ); $b } @{ $self->chain };
    return $last->output;
}

sub has_input {
    return grep { $_->has_input } @{ shift->chain };
}

1;

