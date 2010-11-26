
package OpenData::BR::Federal::PortalTransparencia;

use Moose::Role;
use OpenData::Array;

with 'OpenData::BR::Federal::PortalTransparencia::Page';

with 'OpenData::BR::Federal::PortalTransparencia::Servidores';
with 'OpenData::BR::Federal::PortalTransparencia::CEIS';
with 'OpenData::BR::Federal::PortalTransparencia::Convenios';

has dept => (
    is => 'rw',
    isa => 'Str',
    default => 1
);

has current_collection => (
    is  => 'rw',
    isa => 'Str',
    predicate => 'has_current_collection',
    clearer => 'clear_current_collection',
    trigger => sub  {
        my ($self, $new, $old ) = @_;

        $self->items->collection( $new );
    },
);

has items => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
            return OpenData::Array
                ->new_with_traits(traits => 'MongoDB',
                    host => 'localhost',
                    );
        }
);


sub BUILD {
    my $self = shift;
#    $self->set_browser('Mechanize');
}

sub _run {
    my $self = shift;

    $self->confess( 'Must set a current_collection first!' ) unless $self->has_current_collection;

    my $meth_name = '_run_'. $self->current_collection;
    $self->confess( 'There is no method '. $meth_name ) unless $self->can( $meth_name );
    return eval '$self->' . $meth_name;
}


sub process {
    my $self = shift;

    #$self->items->collection('servidores');
    #$self->items->collection('ceis');
    #$self->items->collection('convenios');

    $self->current_collection('convenios');
    return $self->_run;
}

1;


