#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../lib";

use DataFlow 1.111450;
use Data::Dumper;

my $flow = DataFlow->new(
    [
        'EGov::BR::Federal::PortalTransparencia::Util::Paginar' =>
          { first_page => -1, deref => 1, },
        'URLRetriever',
        HTMLFilter => {
            search_xpath =>
              '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
        },
        HTMLFilter => {
            search_xpath => '//td',
            result_type  => 'VALUE',
            ref_result   => 1,
        },
        sub {    # remove leading and trailing spaces
            local $_ = shift;
            s/^\s*//;
            s/\s*$//;
            return $_;
        },
        Encoding => { from => 'iso-8859-1', to          => 'utf8' },
        NOP      => { name => 'espiando',   dump_output => 1, },
        CSV      => {
            name          => 'csv',
            direction     => 'TO_CSV',
            text_csv_opts => { binary => 1 },
            headers       => [
                'CNPJ/CPF',   'Nome/Razão Social/Nome Fantasia',
                'Tipo',       'Data Inicial',
                'Data Final', 'Nome do Órgão/Entidade',
                'UF',         'Fonte',
                'Data'
            ],
            dump_output => 1,
        },
        SimpleFileOutput => { file => '> /tmp/ceis.csv', ors => "\n" },
    ],
);

##############################################################################

my $base = q{http://www.portaltransparencia.gov.br} . '/'
  . q{ceis/EmpresasSancionadas.asp?paramEmpresa=0};

$flow->input($base);

my @res = $flow->flush;

#print Dumper(\@res);

