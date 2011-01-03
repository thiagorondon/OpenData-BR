
package OpenData::Flow::Node::Chain;

use Moose;
extends 'OpenData::Flow::Node';

use OpenData::Flow::Node;
use List::Util qw/reduce/;

has links => (
    is       => 'ro',
    isa      => 'ArrayRef[OpenData::Flow::Node]',
    required => 1,
);

has '+process_item' => (
    default => sub {
        return sub { }
    },
);

sub input {
    my $self = shift;
    $self->links->[0]->input(@_);
#use Data::Dumper;
#warn 'chain :: links = '.Dumper($self->links);
}

sub output {
    my $self = shift;
    return unless $self->has_queued_data;

#use Data::Dumper;
#warn 'chain :: output :: links = '.Dumper($self->links);
#local $, = "\n";
#warn 'chain :: links queues = ', map { Dumper($_->_queue) } @{ $self->links };
    my $n = @{ $self->links };
    $self->confess('Chain has no nodes, cannot process_item()') if $n == 0;

    my $first = $self->links->[0];
    return $first->output if $n == 1;

    my $last = reduce { $b->input( $a->output ); $b } @{ $self->links };
    #use Data::Dumper; warn 'last = '.Dumper($last);
    #my $t = $last->output;
    #warn 't = ' .Dumper($t);
    #return scalar $last->output() unless wantarray;
    #return $last->output();
    #if( wantarray ) {
    #    my @r = $last->output;
    #    use Data::Dumper; warn 'links result (@) = '.Dumper(@r);
    #    use Data::Dumper; warn 'last = '.Dumper($last);
    #    return @r;
    #}
    #else {
    #    my $r = $last->output;
    #    use Data::Dumper; warn 'links result ($) = '.Dumper($r);
    #    use Data::Dumper; warn 'last = '.Dumper($last);
    #    return $r;
    #}
    return ( $last->output ) if wantarray;
    return scalar $last->output;

}

sub has_queued_data {
    return grep { $_->has_queued_data } @{ shift->links };
}

1;

