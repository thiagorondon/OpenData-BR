package EGov::BR::Federal::PortalTransparencia::Flows::DespesasN0;

use strict;
use warnings;

use Moose;
extends 'DataFlow' => { -version => 1.111600 };

use namespace::autoclean;

use DataFlow::Proc::HTMLFilter;
use DataFlow::Policy::WithSpec;

use URI;

has '_site' => (
    is       => 'ro',
    isa      => 'Str',
    init_arg => undef,
    lazy     => 1,
    default  => q{http://www.portaldatransparencia.gov.br},
);

has 'BASE' => (
    is       => 'ro',
    isa      => 'Str',
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        return join( '/',
            $self->_site, q{PortalComprasDiretasAtividadeEconomica.asp} );
    },
);

has 'link_text' => (
    is       => 'ro',
    isa      => 'DataFlow',
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        return DataFlow->new(
            [
                [
                    HTMLFilter => {
                        search_xpath => '//a',
                        type         => 'VALUE',
                    }
                ]
            ]
        );
    },
);

has 'link_href' => (
    is       => 'ro',
    isa      => 'DataFlow',
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        return DataFlow->new(
            [
                [
                    HTMLFilter => {
                        search_xpath => '//a/@href',
                        type         => 'VALUE',
                    }
                ]
            ]
        );
    },
);

has 'cleartdtag' => (
    is       => 'ro',
    isa      => 'DataFlow',
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        return DataFlow->new(
            [
                [
                    HTMLFilter => {
                        search_xpath => '//td',
                        type         => 'VALUE',
                    }
                ]
            ]
        );
    },
);

has 'splitlink' => (
    is       => 'ro',
    isa      => 'DataFlow',
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        return DataFlow->new(
            sub {
                my ( $text, $href ) = (
                    $self->link_text->process($_),
                    $self->link_href->process($_)
                );
                if ( $text && $href ) {
                    return ( $text, $href );
                }
                else {
                    return ( $self->cleartdtag->process($_), '' );
                }
            }
        );
    },
);

has '+procs' => (
    init_arg => undef,
    lazy     => 1,
    default  => sub {
        my $self = shift;
        return [
            sub {
                my $u = URI->new( $self->BASE );
                $u->query_form( $u->query_form, Ano => $_ );
                return $u->as_string;
            },
            'EGov::BR::Federal::PortalTransparencia::Util::Paginar',
            [ NOP => { deref => 1 } ],
            'URLRetriever',
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
                        my $split = [ $self->splitlink->process($first) ];
                        $split->[1] = join( '/', $self->_site, $split->[1] )
                          if $split->[1];
                        return [
                            @{$split}, map { $self->cleartdtag->process($_) } @d
                        ];
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
            [ Encoding => { from => 'iso-8859-1', to => 'utf8' } ],
        ];
    },
);

1;

