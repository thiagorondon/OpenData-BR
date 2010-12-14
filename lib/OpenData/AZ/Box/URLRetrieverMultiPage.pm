
package OpenData::AZ::Box::URLRetrieverMultiPage;

use Moose;
extends 'OpenData::AZ::Box::URLRetriever';

use Carp;

has first_page => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
);

has last_page => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        carp q{OpenData::AZ::Box::URLRetrieverMultiPage: paged_url not set!}
          unless $self->has_paged_url;
        return $self->produce_last_page->($self->_paged_url);
    },
);

has produce_last_page => (
    is      => 'ro',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub { shift->confess(q{produce_last_page not implemented!}); },
);

# calling convention for the sub:
#   - $self
#   - $paged_url (Str)
#   - $page      (Int)
has make_page_url => (
    is       => 'ro',
    isa      => 'CodeRef',
    required => 1,
);

has _paged_url => (
    is        => 'rw',
    isa       => 'Str',
    predicate => 'has_paged_url',
    clearer   => 'clear_paged_url',
);

has '+process_item' => (
    default => sub {
        return sub {
            my ( $self, $paged_url ) = @_;

            $self->_paged_url($paged_url);

            my $result = [ map { $self->make_page_url->( $self, $paged_url, $_ ) }
                  $self->first_page .. $self->last_page ];

            $self->clear_paged_url;
            return $result;
          }
    },
);

1;

