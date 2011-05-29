package EGov::BR::Federal::PortalTransparencia::Flows::CEIS;

use strict;
use warnings;

use namespace::autoclean;

use autobox;
use DataFlow 1.111450;
use Params::Validate 0.98 qw(:all);

sub new {
    my $self = shift;
    my %opts = validate(
        @_,
        {
            first_page =>
              { type => SCALAR, regex => qr/^\-?\d+$/, optional => 1 },
            last_page => { type => SCALAR, regex => qr/^\d+$/, optional => 1 },
            converter      => { type => SCALAR,  optional => 1 },
            converter_opts => { type => HASHREF, optional => 1 },
        },
    );

    my $opt_pg = { deref => 1 };
    $opt_pg->{first_page} = $opts{first_page} if exists $opts{first_page};
    $opt_pg->{last_page}  = $opts{last_page}  if exists $opts{last_page};

    my $procs = [
        'EGov::BR::Federal::PortalTransparencia::Util::Paginar' => $opt_pg,
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
        Encoding => { from => 'iso-8859-1', to => 'utf8' },
    ];
    push( @{$procs}, $opts{converter} ) if exists $opts{converter};
    die q{Parameter 'converter_opts' requires the parameter 'converter'}
      if ( !exists $opts{converter} && $opts{converter_opts} );
    push( @{$procs}, $opts{converter_opts} ) if exists $opts{converter_opts};

    my $flow = DataFlow->new($procs);

    my $base = q{http://www.portaltransparencia.gov.br} . '/'
      . q{ceis/EmpresasSancionadas.asp?paramEmpresa=0};

    $flow->input($base);

    return $flow;
}

1;

