
package EGov::BR::Federal::PortalTransparencia::Convenios::Item;

use Moose;
use List::MoreUtils qw/mesh/;

with 'OpenData::Provider::Collection::Item';

has '+id' => ( default => 'ConveniosItem', );

has numero => ( is => 'ro', isa => 'Str', writer => '_numero', );
has numero_original =>
  ( is => 'ro', isa => 'Str', writer => '_numero_original', );
has uf     => ( is => 'ro', isa => 'Str', writer => '_uf', );
has objeto => ( is => 'ro', isa => 'Str', writer => '_objeto', );
has orgao_superior =>
  ( is => 'ro', isa => 'Str', writer => '_orgao_superior', );
has concedente => ( is => 'ro', isa => 'Str', writer => '_concedente', );
has convenente => ( is => 'ro', isa => 'Str', writer => '_convenente', );
has valor_conveniado =>
  ( is => 'ro', isa => 'Str', writer => '_valor_conveniado', );

sub elements_list {
    return [
        qw/numero numero_original uf objeto orgao_superior concedente
          convenente valor_conveniado/
    ];
}

sub new_from_array {
    my $pkg = shift;
    my $data = shift || '';

    die unless $pkg eq __PACKAGE__;

    no warnings;
    my @data = map { $_ =~ s/^\s*//; $_ =~ s/\s*$//; $_ } @{$data};
    my $item = __PACKAGE__->new( { mesh @{ elements_list() }, @data } );

    return $item;
}

1;

