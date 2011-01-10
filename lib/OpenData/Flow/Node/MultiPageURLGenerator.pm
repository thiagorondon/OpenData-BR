
package OpenData::Flow::Node::MultiPageURLGenerator;

use Moose;
extends 'OpenData::Flow::Node';

use Carp;

has first_page => (
    is      => 'ro',
    isa     => 'Int',
    default => 1,
);

has last_page => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
    lazy     => 1,
    default  => sub {
        my $self = shift;

        #warn 'last_page';
        carp q{OpenData::Flow::Node::MultiPageURLGenerator: paged_url not set!}
          unless $self->has_paged_url;
        return $self->produce_last_page->( $self->_paged_url );
    },
);

# calling convention for the sub:
#   - $self
#   - $url (Str)
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
            my ( $self, $url ) = @_;

            #warn 'multi page process item, url = '.$url;
            $self->_paged_url($url);

            #use Data::Dumper;
            #print STDERR Dumper($self);

            my $first = $self->first_page;
            my $last  = $self->last_page;
            $first = 1 + $last + $first if $first < 0;

            my @result =
              map { $self->make_page_url->( $self, $url, $_ ) } $first .. $last;

            #use Data::Dumper;
            #warn 'url list = ' . Dumper($result);
            $self->clear_paged_url;
            return @result;
          }
    },
);

1;

