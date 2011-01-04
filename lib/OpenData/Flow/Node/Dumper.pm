package OpenData::Flow::Node::Dumper;

use Moose;
extends 'OpenData::Flow::Node';

use Data::Dumper;

has '+process_item' => (
    default => sub {
        return sub {
            shift;
            my $item = shift;
            print STDERR Dumper($item);
            return $item;
        }
    }
);

1;

__END__

=pod

=head1 NAME

OpenData::Flow::Node::Dumper - Dumper node, will print every input item to STDERR with Data::Dumper

=head1 SYNOPSIS

    use OpenData::Flow::Dumper;

    my $nop = OpenData::Flow::Node::Dumper->new;

    my $result = $nop->process( 'abc' );
    # $result == undef

=head1 DESCRIPTION

Dumper node. Every item passed to its input will be printed in the C<STDERR>
file handle, using L<Data::Dumper>.

=head1 METHODS

The interface for C<OpenData::Flow::Node::Dumper> is the same of
C<OpenData::Flow::Node>.

=head1 DEPENDENCIES

L<Data::Dumper>

L<OpenData::Flow::Node>

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
