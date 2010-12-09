
use OpenData::Simple;

my $opendata = provider {
    
    name => 'PortalTransparencia',
    description => 'Portal da Transparencia',
    url => 'http://portaltransparencia.gov.br',
    
    default_loader => 'Dumper',
    default_extract => 'HTTP',

    collections => [ {
        name => 'Page',
        url_add => 'ceis/EmpresasSancionadas.asp?paramEmpresa=0',
    } ]

};


