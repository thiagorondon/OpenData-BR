
package Transformer;

use Moose;
use Spreadsheet::ParseExcel;

my $parser = Spreadsheet::ParseExcel->new();

sub transform {
    my $self = shift;
    my $data = shift; # filename ?

    my $workbook = $parser->parse($data);

    if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }

    my @all_cols;

    for my $worksheet ( $workbook->worksheets() ) {

        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();
        
        my @data;
        
        for my $row ( $row_min .. $row_max ) {
    #        print join(';', @data) . "\n" if scalar(@data);
            push ( @all_cols, @data ) if scalar(@data);
            @data = ();
            for my $col ( $col_min .. $col_max ) {

                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
                my $value = $cell->value();
                next if !length($value);
                push ( @data, $value );
            }
        }
    }
    return [ @all_cols ];
}


1;

package Extractor;

use Moose;
#extends 'OpenData::Extractor::File' ?;

sub extract { 'total_populacao_acre.xls'; }

1;

package main;

use FindBin qw($Bin);
use lib "$Bin/../../lib";

use strict;
use warnings;

use OpenData::Simple;
use OpenData::Array;

my $opendata = provider {
    
    name => 'CENSO2010',
    description => 'CENSO 2010 - POPULACAO POR MUNICIPIO',
    url => 'http://www.ibge.gov.br/home/estatistica/populacao/censo2010/populacao_por_municipio_zip.shtm',
    
    collections => [ {
        id => 'ACRE',
        extractor =>  Extractor->new,
        transformer => Transformer->new,
        loader => OpenData::Array->new_with_traits( traits => 'Dumper' )
    } ]

};

$opendata->process('ACRE');



