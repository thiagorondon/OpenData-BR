use Test::More tests => 7;

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

my $res = $t->( [ $content ] );

use Data::Dumper;
diag(Dumper($res) );

ok( $t->transform(undef) == undef );
