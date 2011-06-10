#!/usr/bin/env perl

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../lib";

use Data::Printer colored => 0;

use EGov::BR::Federal::PortalTransparencia::Flows::CEIS;

my $ceis = EGov::BR::Federal::PortalTransparencia::Flows::CEIS->new(

# PARA RESTRINGIR PAGINAS A SEREM SCRAPE-ADAS, USE OS PARÂMETROS:
#    first_page => -1,
#    last_page => 50,
);

my $flow = DataFlow->new( [
	$ceis,
	[ CSV => {
        name          => 'csv',
        direction     => 'CONVERT_TO',
        text_csv_opts => { binary => 1, sep_char => ';', },
        headers       => [
            'CNPJ/CPF',   'Nome/Razão Social/Nome Fantasia',
            'Tipo',       'Data Inicial',
            'Data Final', 'Nome do Órgão/Entidade',
            'UF',         'Fonte',
            'Data'
        ],
        dump_output => 1,
     },
	 ],
	 ] );


$flow->input($ceis->BASE_URL);
my @res = $flow->flush;
p @res;

#print Dumper( \@res );

