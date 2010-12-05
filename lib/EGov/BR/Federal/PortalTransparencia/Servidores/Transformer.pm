
package EGov::BR::Federal::PortalTransparencia::Servidores::Transformer;

use Moose;
use aliased 'EGov::BR::Federal::PortalTransparencia::Servidores::Item';

extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//table[@summary="Lista de Servidores"]/tr[position()>1]', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;
    my $item = Item->new_from_array($data);
    return $item;
}

1;

