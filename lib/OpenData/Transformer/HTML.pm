
package OpenData::Transformer::HTML;

use Moose;
use Scalar::Util qw/reftype/;
use HTML::TreeBuilder::XPath;

with 'OpenData::Transformer';

has node_xpath => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has value_xpath => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has _data => (
    is  => 'rw',
    isa => 'Any',
);

sub _transform_element {
    my $self = shift;
    return @_;
}

sub transform {
    my $self = shift;
    my $raw  = shift;

    return unless reftype($raw) eq 'ARRAY' and scalar( @{$raw} );

    $self->_data( [] );
    foreach my $part ( @{$raw} ) {
        my $tree  = HTML::TreeBuilder::XPath->new_from_content($part);
        my $nodes = $tree->findnodes( $self->node_xpath );

        $self->confess( 'Cannot match node_xpath (' . $self->node_xpath . ')' )
          unless scalar( @{$nodes} );

        foreach my $value ( @{$nodes} ) {
            my $cut = [ $value->findvalues( $self->value_xpath ) ];

            $self->confess(
                'Cannot match value_xpath (' . $self->value_xpath . ')' )
              unless scalar( @{$cut} );

            my $d = $self->_transform_element($cut);
            push @{ $self->data }, $d;
        }
        $tree->delete;
    }

    return $self->_data;
}

1;

