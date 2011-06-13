#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../lib";

use Data::Printer colored => 0;

use DataFlow 1.111560;
use DataFlow::Proc;
use aliased 'DataFlow::Proc::HTMLFilter';
use aliased 'DataFlow::Policy::WithSpec';

use URI;

my $site = q{http://www.portaldatransparencia.gov.br};
my $base = join( '/', $site, q{PortalComprasDiretasAtividadeEconomica.asp} );

my $link_text = HTMLFilter->new(
    search_xpath => '//a',
    type         => 'VALUE',
);
my $link_href = HTMLFilter->new(
    search_xpath => '//a/@href',
    type         => 'VALUE',
);
my $cleartdtag = HTMLFilter->new(
    search_xpath => '//td',
    type         => 'VALUE'
);
my $splitlink = DataFlow->new(
    sub {
		my ($text,$href) = ( $link_text->process($_), $link_href->process($_) );
		if ( $text && $href ) {
			return ($text,$href);
		}
		else {
			return ( $cleartdtag->process($_), '' );
		}
    }
);

my $flow = DataFlow->new(
    [
        sub {
            my $u = URI->new($base);
            $u->query_form( $u->query_form, Ano => $_ );
            return $u->as_string;
        },
		'EGov::BR::Federal::PortalTransparencia::Util::Paginar',
		[ NOP => { deref => 1 } ],
        'URLRetriever',
        [ Encoding => { from => 'iso-8859-1', to => 'utf8' } ],
        [
            HTMLFilter =>
              { search_xpath => '//div[@id="listagem"]/table//tr/td/..', }
        ],
        [
            HTMLFilter => {
                search_xpath => '//td',
                ref_result   => 1,
            }
        ],
        [
            Proc => {
                name   => 'split-proc',
                policy => 'ScalarOnly',
                p      => sub {
                    my ( $first, @d ) = @{$_};
                    my $split = [ $splitlink->process($first) ];
                    $split->[1] = join( '/', $site, $split->[1] ) if $split->[1];
                    return [ @{$split}, map { $cleartdtag->process($_) } @d ];
                },
            }
        ],
		#[ NOP => { name => 'pos-URL', dump_output => 1 } ],
        [
            Proc => {
                policy => 'Scalar',
                p      => sub {
                    $_->[2] =~ s/\.//g;
                    $_->[2] =~ s/,/./g;
                    return $_;
                },
            }
        ],
        sub {    # remove leading and trailing spaces
            s/^\s*//;
            s/\s*$//;
            return $_;
        },
    ]
);

my $ano = shift || eval { use DateTime; DateTime->now->year - 1 };

$flow->input($ano);
my @res = $flow->flush;

p @res;

