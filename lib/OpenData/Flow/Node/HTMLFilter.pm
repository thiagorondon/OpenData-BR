
package OpenData::Flow::Node::HTMLFilter;

use Moose;
extends 'OpenData::Flow::Node';

use Moose::Util::TypeConstraints;
use HTML::TreeBuilder::XPath;

has search_xpath => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

enum _result_type => [qw(NODE HTML VALUE)];

has result_type => (
    is      => 'ro',
    isa     => '_result_type',
    default => 'HTML',
);

has ref_result => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has '+process_item' => (
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $proc = sub {
            my ( $self, $item ) = @_;

            #use Data::Dumper; warn 'htmlfilter::process_item: '.Dumper($item);
            my $html = HTML::TreeBuilder::XPath->new_from_content($item);

            #warn 'xpath is built';
            #warn 'values if VALUES';
            return $html->findvalues( $self->search_xpath )
	          if $self->result_type eq 'VALUE';

            #warn 'not values, find nodes';
            my @result = $html->findnodes( $self->search_xpath );

            #use Data::Dumper; warn 'result = '.Dumper(\@result);
            return () unless @result;
            return @result if $self->result_type eq 'NODE';

            #warn 'wants HTML';
            return map { $_->as_HTML } @result;
        };
        
        return $self->ref_result ? sub { return [ $proc->(@_) ] } : $proc;
    },
);

1;

__END__

=pod

=head1 NAME

OpenData::Flow::Node::HTMLFilter - A filter node for HTML content.

=head1 SYNOPSIS

    use OpenData::Flow::Node::HTMLFilter;

    my $filter_html = OpenData::Flow::Node::HTMLFilter->new(
        search_xpath => '//td',
    	result_type  => 'HTML',
	);

    my $filter_value = OpenData::Flow::Node::HTMLFilter->new(
        search_xpath => '//td',
    	result_type  => 'VALUE',
	);

    my $input = <<EOM;
    <html><body>
      <table>
        <tr><td>Line 1</td><td>L1, Column 2</td>
        <tr><td>Line 2</td><td>L2, Column 2</td>
      </table>
    </html></body>
    EOM

    $filter_html->input( $input );
    # @result == '<td>Line 1</td>', ... '<td>L2, Column 2</td>'

    $filter_value->input( $input );
    # @result == q{Line 1}, ... q{L2, Column 2}

=head1 DESCRIPTION

This node type provides a filter for HTML content.
Each item will be considered as a HTML content and will be filtered
using L<HTML::TreeBuilder::XPath>.

=head1 ATTRIBUTES

=head2 search_xpath

This attribute is a XPath string used to filter down the HTML content.
The C<search_xpath> attribute is mandatory.

=head2 result_type

This attribute is a string, but its value B<must> be one of:
C<HTML>, C<VALUE>, C<NODE>. The default is C<HTML>.

=head3 HTML

The result will be the HTML content specified by C<search_xpath>.

=head3 VALUE

The result will be the literal value enclosed by the tag and/or attribute
specified by C<search_xpath>.

=head3 NODE

The result will be a list of L<HTML::Element> objects, as returned by the
C<findnodes> method of L<HTML::TreeBuilder::XPath> class.

Most people will probably use C<HTML> or C<VALUE>, but this option is also
provided in case someone wants to manipulate the HTML elements directly.

=head2 ref_result

This attribute is a boolean, and it signals whether the result list should be
added as a list of items to the output queue, or as a reference to an array
of items. The default is 0 (false).

There is a semantic subtlety here: if C<ref_result> is 1 (true),
then one HTML item (input) may generate one or zero ArrayRef item (output),
i.e. it is a one-to-one mapping.
On the other hand, by keeping C<ref_result> as 0 (false), one HTML item
may produce any number of items as result,
i.e. it is a one-to-many mapping.

=head1 METHODS

The interface for C<OpenData::Flow::Node::HTMLFilter> is the same of
C<OpenData::Flow::Node>, plus the accessor methods for the attributes
described above.

=head1 DEPENDENCIES

L<OpenData::Flow::Node>

L<HTML::TreeBuilder::XPath>

L<HTML::Element>

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

