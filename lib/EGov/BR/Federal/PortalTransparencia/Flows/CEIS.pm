package EGov::BR::Federal::PortalTransparencia::Flows::CEIS;

use strict;
use warnings;

use Moose;
extends 'DataFlow' => { -version => 1.111600 };

use namespace::autoclean;

use EGov::BR::Federal::PortalTransparencia::Util::Paginar;

has 'BASE_URL' => (
    is      => 'ro',
    default => q{http://www.portaltransparencia.gov.br} . '/'
      . q{ceis/EmpresasSancionadas.asp?paramEmpresa=0},
    init_arg => undef
);

has 'first_page' => (
    'is'  => 'ro',
    'isa' => 'Int',
);

has 'last_page' => (
    'is'  => 'ro',
    'isa' => 'Int',
);

has '_pager' => (
    is      => 'ro',
    isa     => 'EGov::BR::Federal::PortalTransparencia::Util::Paginar',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my $opt_pg = { deref => 1 };
        $opt_pg->{first_page} = $self->first_page if $self->first_page;
        $opt_pg->{last_page}  = $self->last_page  if $self->last_page;

        return EGov::BR::Federal::PortalTransparencia::Util::Paginar->new(
            $opt_pg);
    },
    init_arg => undef,
);

has '+procs' => (
    lazy    => 1,
    default => sub {
        my $self = shift;
        return [
            $self->_pager,
            'URLRetriever',
            [
                HTMLFilter => {
                    search_xpath =>
                      '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
                }
            ],
            [
                HTMLFilter => {
                    search_xpath => '//td',
                    result_type  => 'VALUE',
                    ref_result   => 1,
                }
            ],
            sub {    # remove leading and trailing spaces
                s/^\s*//;
                s/\s*$//;
                return $_;
            },
            [ Encoding => { from => 'iso-8859-1', to => 'utf8' } ],
        ];
    }
);

1;

