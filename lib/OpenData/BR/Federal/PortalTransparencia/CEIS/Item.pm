
package OpenData::BR::Federal::PortalTransparencia::CEIS::Item;

use Moose;
use List::MoreUtils qw/mesh/;

with 'OpenData::Provider::Collection::Item';

has '+id' => (
    default => 'CEISItem',
    lazy    => 1,
);

has cpfcnpj      => ( is => 'ro', isa => 'Str', writer => '_cpfcnpj', );
has nome         => ( is => 'ro', isa => 'Str', writer => '_nome', );
has tipo         => ( is => 'ro', isa => 'Str', writer => '_tipo', );
has data_inicial => ( is => 'ro', isa => 'Str', writer => '_data_inicial', );
has data_final   => ( is => 'ro', isa => 'Str', writer => '_data_final', );

has orgao_sancionador => (
    is     => 'ro',
    isa    => 'Str',
    writer => '_orgao_sancionador',
);

has uf         => ( is => 'ro', isa => 'Str', writer => '_uf', );
has fonte      => ( is => 'ro', isa => 'Str', writer => '_fonte', );
has fonte_data => ( is => 'ro', isa => 'Str', writer => '_fonte_data', );

sub elements_list {
    return [
        qw/cpfcnpj nome tipo data_inicial data_final orgao_sancionador
          uf fonte fonte_data/
    ];
}

sub new_from_array {
    my $pkg = shift;
    my $data = shift || '';

    die unless $pkg eq __PACKAGE__;

    no warnings;
    my @data = map { $_ =~ s/^\s*//; $_ =~ s/\s*$//; $_ } @{$data};
    my $item = __PACKAGE__->new( { mesh @{ elements_list() }, @data } );

    $item->_uf( uc( $item->uf ) );

    return $item;
}

1;

