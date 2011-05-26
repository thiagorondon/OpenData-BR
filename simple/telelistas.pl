
package Transformer;

use Moose;

# extends OpenData::Transformer::OCR ?

sub transform {
    my $self = shift;
    my $data = shift;

    #my $image = shift;
    #open my $fh, '>', "/tmp/$cep" or die $!;
    #print $fh $image;
    #close $fh;

    return 'ok';
}

1;

package Extractor;

use Moose;
extends 'OpenData::Extractor::HTTP';

my $cep = '04002-002';

# pq o HTTP deve exigir o URL ?
has '+URL' => ( default => sub { 'http://telelistas.net/templates/cep.aspx' } );

sub extract { &_doform; }

sub _doform {
    my $self = shift;
    $self->get('http://telelistas.net/templates/cep.aspx');
    $self->browser->submit_form(
        form_name => 'formCEP',
        fields    => { cep => $cep },
    );
    $self->browser->submit_form( form_name => 'redereciona' );
    my $content = $self->get(
'http://www.buscacep.correios.com.br/servicos/dnec/ListaDetalheCEPImage?TipoCep=2&Posicao=1'
    );
    return [$content];
}

1;

package main;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use strict;
use warnings;

use OpenData::Simple;
use OpenData::Array;

my $opendata = provider {

    name        => 'CEPs',
    description => 'CEPs dos correios',
    url         => 'http://www.correios.com.br/',

    collections => [
        {
            id          => 'CEPs',
            extractor   => Extractor->new,
            transformer => Transformer->new,
            loader => OpenData::Array->new_with_traits( traits => 'Dumper' )
        }
      ]

};

$opendata->process('CEPs');

