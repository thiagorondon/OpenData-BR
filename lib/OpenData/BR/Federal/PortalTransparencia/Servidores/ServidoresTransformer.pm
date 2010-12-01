
package OpenData::BR::Federal::PortalTransparencia::Servidores::ServidoresTransformer;

use Moose;
use OpenData::BR::Federal::PortalTransparencia::Servidores::ServidoresItem;

use Data::Dumper;

extends 'OpenData::Transformer::HTML';

has '+node_xpath' =>
  ( default => '//table[@summary="Lista de Servidores"]/tr[position()>1]', );

has '+value_xpath' => ( default => '//td', );

sub _transform_element {
    my $self = shift;
    my $data = shift;

    #warn 'data = '. Dumper($data);
    my $item =
      OpenData::BR::Federal::PortalTransparencia::Servidores::ServidoresItem
      ->new_from_array($data);

    return $item;
}

1;

