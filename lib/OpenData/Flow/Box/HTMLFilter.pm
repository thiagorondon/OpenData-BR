
package OpenData::Flow::Box::HTMLFilter;

use Moose;
extends 'OpenData::Flow::Box';

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

has '+process_item' => (
    default => sub {
        return sub {
            my ( $self, $item ) = @_;
            #use Data::Dumper;
            #warn 'htmlfilter :: process_item :: item = '.Dumper($item);
            #warn 'htmlfilter :: process_item :: self = '.Dumper($self);
            my $html = HTML::TreeBuilder::XPath->new_from_content($item);
            #warn 'xpath is built';

            return [ $html->findvalues( $self->search_xpath ) ]
              if $self->result_type eq 'VALUE';

            #warn 'want NODE or HTML';

            my @result = $html->findnodes( $self->search_xpath );
            #warn 'result = '.Dumper(\@result);
            return [] unless @result;

            return [
                  $self->result_type eq 'NODE'
                ? @result
                : map { $_->as_HTML } @result
            ];
          }
    },
);

1;

