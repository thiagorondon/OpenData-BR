
package OpenData::App::Getopt;

use Carp;
use Moose;
use Moose::Util::TypeConstraints;

with 'MooseX::Getopt';

our %traits = (
    portaldatransparencia => 'BR::Federal::PortalTransparencia'
);

has 'debug' => (
    is => 'rw',
    isa => 'Bool',
    default => 1
);

has 'provider' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'Ex. portaldatransparencia'
);

has 'collection' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'Ex. convenios'
);

has 'browser' => (
    is => 'rw',
    isa => 'Str',
    required => 1,
    documentation => 'Ex. Curl, Mechaninze'
);

has '_trait' => (
    is => 'ro',
    isa => 'Str',
    lazy => 1,
    default => sub { $traits{shift->provider} || '' }
);

1;
