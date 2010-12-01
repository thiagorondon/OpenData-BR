
use MongoDB;
use Data::Dumper;

my $conn = MongoDB::Connection->new();

my $db   = $conn->opendata;
my $coll = $db->convenios;

#print $coll->name . "\n";
#print $coll->count . "\n";

#my @values = $coll->query({}, { limit => 5 })->all;
my $cursor = $coll->query;

my @fields =
  qw/uf municipio publicacao n_original valor_convenio orgao_superior SIAFI situacao data_ultima_liberacao valor_contrapartida municipio valor_liberado convenente concedente valor_ultima_liberacao objeto_do_convenio fim_vigencia inicio_vigencia/;

print join( ';', 'created', @fields, "\n" );

while ( $cursor->has_next ) {
    my $data = $cursor->next;

    my @item;
    push( @item, $data->{created} );
    push( @item, $data->{row}{$_} ) for @fields;

    print join( ';', @item, "\n" );
}

