
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

            #use Data::Dumper;
            #warn 'htmlfilter :: process_item :: item = '.Dumper($item);
            #warn 'htmlfilter :: process_item :: self = '.Dumper($self);
            my $html = HTML::TreeBuilder::XPath->new_from_content($item);

            #warn 'xpath is built';
            if ( $self->result_type eq 'VALUE' ) {

                #warn 'wants VALUE';
                my @res = $html->findvalues( $self->search_xpath );

                #warn 'VALUE result = ' . Dumper(@res);
                #warn '=' x 20;
                return @res;
            }

            #warn 'find nodes';
            my @result = $html->findnodes( $self->search_xpath );

            #warn 'result = '.Dumper(\@result);
            return () unless @result;
            return @result if $self->result_type eq 'NODE';

            #warn 'wants HTML';
            return map { $_->as_HTML } @result;
        };
        return $self->ref_result ? sub { return [ $proc->(@_) ] } : $proc;
    },
);

1;

