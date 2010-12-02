
package OpenData;

use Moose;
use namespace::autoclean;
use JSON::XS;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

sub _build_config {
    my $filename = $ENV{OpenData_config};
    return {} if !-e $filename;

    return JSON::XS->new->decode( scalar file($filename)->slurp( chomp => 1 ) );
}

=head1 NOME

OpenData-BR - Plataforma para busca de dados públicos brasileiros.

=head1 SINOPSE

Veja o L<OpenData::Manual> para verificar todos os documentos e tutoriais disponíveis.

    #!/usr/bin/env perl

    use strict;
    use warnings;

    use OpenData::Runtime;
    use OpenData::BR::Federal::PortalTransparencia;

    my $opendata = new OpenData::BR::Federal::PortalTransparencia->new;

    $opendata->add_collection_servidores;
    $opendata->add_collection_ceis;
    $opendata->add_collection_convenios;

    my $data = $opendata->process('ceis');

=head1 DESCRIÇÃO

OpenData-br é plataforma desenvolvida para facilitar o desenvolvimento de aplicativos que buscam dados em portais do governo federal e gerem dados em formato opendata.

O principal objetivo é oferecer esta facilidade para que o programador se preocupe mais em como buscar o dado almejado e não com detalhes que são sempre comuns neste processo.

=head1 Métodos internos

Estes métodos não são recomendados para serem utilizados pelos usuários.

=head2 version

Retorna o número da versão do OpenData-BR.

=cut

sub version { $VERSION }

=head1 SUPORTE

IRC:

    No canal #opendata-br na rede irc.perl.org

Comunidade:

    São Paulo Perl Mongers - http://sao-paulo.pm.org/

Web:

    http://www.opendatabr.org/

=head1 AUTORES

maluco: Thiago Rondon

russoz: Alexei Znamensky

=head1 LICENÇA

Este aplicativo é um software-livre e você pode redistribuir e/ou modificar nos mesmos termos da licença GPLv2.

=cut

__PACKAGE__->meta->make_immutable;

1;

