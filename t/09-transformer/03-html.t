use Test::More tests => 8;

use strict;

use File::Slurp qw(slurp);
use OpenData::Transformer::HTML;

eval { my $obj = OpenData::Transformer::HTML->new };
ok($@);

my $t = OpenData::Transformer::HTML->new(
    node_xpath  => '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
    value_xpath => '//td',
);

my $content = slurp('./examples/ceis-page.html');
#use Data::Dumper;
#diag(Dumper($content) );

my $res = $t->transform( [ $content ] );
#use Data::Dumper;
#diag(Dumper($res) );

ok( $res->[0]->[2] eq 'Suspensa' );
ok( $res->[0]->[4] eq '2 anos' );
ok( $res->[1]->[6] eq 'DF' );
ok( $res->[6]->[5] eq 'JUNTA COMERCIAL DO ESTADO DE MINAS GERAIS - JUCEMG' );
ok( $res->[8]->[5] eq 'SERPRO' );
ok( $res->[9]->[5] eq 'SUPERIOR TRIBUNAL MILITAR - STM' );

ok( !$t->transform(undef) );
