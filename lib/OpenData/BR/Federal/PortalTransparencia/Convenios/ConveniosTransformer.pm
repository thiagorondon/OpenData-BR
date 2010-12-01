
package OpenData::BR::Federal::PortalTransparencia::Convenios::ConveniosTransformer;

use Moose;
use OpenData::BR::Federal::PortalTransparencia::Convenios::ConveniosItem;

use Data::Dumper;

extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//div[@id="listagemConvenios"]/table/tbody/tr', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;

    #warn 'data = '. Dumper($data);
    my $item =
      OpenData::BR::Federal::PortalTransparencia::Convenios::ConveniosItem
      ->new_from_array($data);
    return $item;
}

1;

