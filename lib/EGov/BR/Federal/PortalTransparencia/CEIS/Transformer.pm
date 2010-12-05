
package EGov::BR::Federal::PortalTransparencia::CEIS::Transformer;

use Moose;
extends 'OpenData::Transformer::HTML';

use aliased 'EGov::BR::Federal::PortalTransparencia::CEIS::Item';

has '+node_xpath' =>
  ( default => '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;

    my $item = Item->new_from_array($data);
    return $item;
}

1;

