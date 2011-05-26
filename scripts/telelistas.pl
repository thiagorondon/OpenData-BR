#!/usr/bin/perl

use strict;
use warnings;
use WWW::Mechanize;
use HTML::TreeBuilder::XPath;

my $cep = $ARGV[0] or die "$0 <cep>\n";
my $mech = WWW::Mechanize->new();

#start
action();

sub action {
    $mech->get('http://telelistas.net/templates/cep.aspx');

    $mech->submit_form(
        form_name => 'formCEP',
        fields    => { cep => $cep },
    );
    $mech->submit_form( form_name => 'redereciona' );
    $mech->get(
'http://www.buscacep.correios.com.br/servicos/dnec/ListaDetalheCEPImage?TipoCep=2&Posicao=1'
    );
    save( $mech->content );
}

sub save {
    my $image = shift;
    open my $fh, '>', "/tmp/$cep" or die $!;
    print $fh $image;
}

