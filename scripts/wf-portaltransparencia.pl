#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use aliased 'OpenData::AZ::Box';
use aliased 'OpenData::AZ::ChainBox';
use aliased 'OpenData::AZ::Box::LiteralData';
use aliased 'OpenData::AZ::Box::HTMLFilter';
use aliased 'OpenData::AZ::Box::URLRetriever';
#use aliased 'OpenData::AZ::Box::URLRetrieverMultiPage';

my $bigbox = ChainBox->new(
    chain => [
        LiteralData->new(
            data =>
q{http://www.portaltransparencia.gov.br/ceis/EmpresasSancionadas.asp?paramEmpresa=0/}
        ),
        URLRetriever->new,
        HTMLFilter->new(
            search_xpath => '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr'
        ),
        HTMLFilter->new( search_xpath => '//td', deref => 1, result_type => 'VALUE'  ),
    ],
);

local $, = "\n";
use Data::Dumper;
print Dumper($bigbox->output);


