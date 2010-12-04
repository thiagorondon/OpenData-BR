
package OpenData::Component;

use Moose;
use Scalar::Util 'blessed';

with 'OpenData::Log';

has component_name => ( is => 'ro' );

around component_name => sub {
    my ($orig, $self) = (shift, shift);
    blessed($self) ? $self->$orig() || blessed($self) : $self;
};

1;

__END__

=head1 NOME

OpenData::Component - Classe para Componente do OpenData.

=head1 AUTORES, LICENÇA e COPYRIGHT

Veja OpenData.pm

=cut

