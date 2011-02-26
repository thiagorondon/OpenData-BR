
package EGov::BR::Federal::PortalTransparencia::Servidores::Item;

use Moose;
use List::MoreUtils qw/mesh/;

with 'OpenData::Provider::Collection::Item';

has '+id' => (
    default => 'ServidoresItem',
    lazy    => 1,
);

has cpf => ( is => 'ro', isa => 'Str', writer => '_cpf', );
has nome_do_servidor =>
  ( is => 'ro', isa => 'Str', writer => '_nome_do_servidor', );

has orgao_lotacao => (
    is     => 'ro',
    isa    => 'Str',
    writer => '_orgao_lotacao',
);

has orgao_exercicio => (
    is     => 'ro',
    isa    => 'Str',
    writer => '_orgao_exercicio',
);

has jornada => ( is => 'ro', isa => 'Str', writer => '_jornada', );

sub elements_list {
    return [qw/cpf nome_do_servidor orgao_lotacao orgao_exercicio jornada/];
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

