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
use aliased 'OpenData::AZ::Box::MultiPageURLGenerator';

use URI;
#use HTML::TreeBuilder::XPath;

my $bigbox = ChainBox->new(
    chain => [
        LiteralData->new(
            data =>
q{http://www.portaltransparencia.gov.br/ceis/EmpresasSancionadas.asp?paramEmpresa=0}
        ),
        MultiPageURLGenerator->new(
            first_page    => 34,
            last_page     => 35,
            make_page_url => sub {
                my ( $self, $url, $page ) = @_;
                my $u = URI->new($url);
                $u->query_form( $u->query_form, Pagina => $page );
                return $u->as_string;
            },
#            produce_last_page => sub{
#                my ($self, $url) = @_;
#
#            },
        ),
        URLRetriever->new( deref => 1 ),
        HTMLFilter->new(
            search_xpath =>
              '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
            deref => 1,
        ),
#        HTMLFilter->new(
#            search_xpath => '//td',
#            deref        => 1,
#            result_type  => 'VALUE',
#        ),
    ],
);

use Data::Dumper;
print Dumper( $bigbox->output );
