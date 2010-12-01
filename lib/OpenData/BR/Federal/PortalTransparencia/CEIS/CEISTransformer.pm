
package OpenData::BR::Federal::PortalTransparencia::CEIS::CEISTransformer;

use Moose;
use OpenData::BR::Federal::PortalTransparencia::CEIS::CEISItem;

use Data::Dumper;

extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;

    #warn 'data = '. Dumper($data);
    my $item =
      OpenData::BR::Federal::PortalTransparencia::CEIS::CEISItem
      ->new_from_array($data);
    return $item;
}

1;

