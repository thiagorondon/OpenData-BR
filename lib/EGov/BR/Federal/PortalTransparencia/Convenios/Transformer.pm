
package EGov::BR::Federal::PortalTransparencia::Convenios::Transformer;

use Moose;
use aliased 'EGov::BR::Federal::PortalTransparencia::Convenios::Item';

extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//div[@id="listagemConvenios"]/table/tbody/tr', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;
    my $item = Item->new_from_array($data);
    return $item;
}

1;

