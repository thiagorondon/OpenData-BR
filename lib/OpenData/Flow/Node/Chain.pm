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
        return sub {
            my ( $self, $item ) = @_;

            #use Data::Dumper;
            #warn 'chain          = '.Dumper($self);
            #warn 'chain :: links = '.Dumper($self->links);
            $self->confess('Chain has no nodes, cannot process_item()')
              unless scalar @{ $self->links };

            $self->links->[0]->input($item);
            my $last =
              reduce { $a->process_input; $b->input( $a->output ); $b }
            @{ $self->links };
            return $last->output;
        },;
    },
);

1;

__END__

=pod

=head1 NAME

OpenData::Flow::Node::Chain - A "super-node" that can link a sequence of nodes

=head1 SYNOPSIS

    use OpenData::Flow::Node;
    use OpenData::Flow::Node::Chain;

    my $chain = OpenData::Flow::Node::Chain->new(
        links => [
            OpenData::Flow::Node->new(
                process_item => sub {
                    shift; return uc(shift);
                }
            ),
            OpenData::Flow::Node->new(
                process_item => sub {
                    shift; return reverse shift ;
                }
            ),
        ],
    );

    my $result = $chain->process( 'abc' );
    # $result == 'CBA'

=head1 DESCRIPTION

This is a L<Moose> based class that provides the idea of a chain of steps in 
a data-flow. 
One might think of it as the actual definition of the data flow, but this is a 
limited, linear, flow, and there is room for a lot of improvements.

A C<OpenData::Flow::Node::Chain> object accepts input like a regular
C<OpenData::Flow::Node>, but it injects that input into the first link of the
chain, and pumps the output of each link into the input of the next one,
similarly to pipes in a shell command line. The output of the last link of the
chain will be used as the output of the entire chain.

=head1 ATTRIBUTES

=head2 links

This attribute is a C<< ArrayRef[OpenData::Flow::Node] >>, and it holds the
actual "chain" of nodes to process the data.

=head1 METHODS

The interface for C<OpenData::Flow::Node::Chain> is the same of
C<OpenData::Flow::Node>, except for the accessor method for C<links>.

=head1 DEPENDENCIES

L<OpenData::Flow::Node>

L<List::Util>

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-opendata@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Alexei Znamensky  C<< <russoz@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Alexei Znamensky C<< <russoz@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
