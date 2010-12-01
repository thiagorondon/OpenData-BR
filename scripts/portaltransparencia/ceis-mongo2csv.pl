
use MongoDB;

my $conn = MongoDB::Connection->new();

my $db     = $conn->opendata;
my $coll   = $db->ceis;
my $cursor = $coll->query;

my @fields =
  qw/nome fonte_data fonte cpfcnpj uf tipo data_inicial data_final orgao_sancionador/;

print join( ';', 'created', @fields, "\n" );

while ( $cursor->has_next ) {
    my $data = $cursor->next;

    my @item;
    push( @item, $data->{created} );
    push( @item, $data->{row}{$_} ) for @fields;

    print join( ';', @item, "\n" );
}

