
package OpenData::App::Getopt;

use Carp;
use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

with 'MooseX::Getopt';

our %providers = 
    ( portaldatransparencia => 'BR::Federal::PortalTransparencia' );

has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 1
);

has 'provider' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    documentation => 'Ex. portaldatransparencia'
);

has 'collection' => (
    is            => 'rw',
    isa           => 'Str',
    required      => 1,
    documentation => 'Ex. convenios'
);

has 'browser' => (
    is            => 'rw',
    isa           => 'Str',
    documentation => 'Ex. Curl, Mechaninze'
);

__PACKAGE__->meta->make_immutable;

1;
