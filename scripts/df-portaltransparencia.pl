#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use aliased 'OpenData::Flow::Chain';
use aliased 'OpenData::Flow::Node::LiteralData';
use aliased 'OpenData::Flow::Node::HTMLFilter';
use aliased 'OpenData::Flow::Node::URLRetriever';
use aliased 'OpenData::Flow::Node::MultiPageURLGenerator';
use aliased 'OpenData::Flow::Node::Dumper' => 'DumperNode';

use URI;
use OpenData::Get;
use HTML::TreeBuilder::XPath;

my $base = join( '/',
    q{http://www.portaltransparencia.gov.br},
    q{ceis}, q{EmpresasSancionadas.asp?paramEmpresa=0} );

my $chain = Chain->new(
    chain => [
        LiteralData->new( data => $base, ),
        MultiPageURLGenerator->new(
            first_page => -2,

            #last_page     => 35,
            make_page_url => sub {
                my ( $self, $url, $page ) = @_;
                my $u = URI->new($url);
                $u->query_form( $u->query_form, Pagina => $page );
                return $u->as_string;
            },
            produce_last_page => sub {
                my $url = shift;

                #print STDERR qq{produce_last_page url = $url\n};
                my $get  = OpenData::Get->new;
                my $html = $get->get($url);

                #print STDERR 'html = '.$html."\n";
                my $texto =
                  HTML::TreeBuilder::XPath->new_from_content($html)
                  ->findvalue('//p[@class="paginaAtual"]');
                die q{Não conseguiu fazer a paginação} unless $texto;
                return $1 if $texto =~ /\d\/(\d+)/;
            },
        ),
        URLRetriever->new( process_into => 1, deref => 1 ),
        HTMLFilter->new(
            search_xpath =>
              '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
            process_into => 1,
        ),
        HTMLFilter->new(
            search_xpath => '//td',
            result_type  => 'VALUE',
            process_into => 1,
            deref        => 1,
        ),
        DumperNode->new,
    ],
);

$chain->flush;

