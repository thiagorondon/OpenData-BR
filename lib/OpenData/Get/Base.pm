
package OpenData::Get::Base;

use Moose::Role;
use namespace::autoclean;

has url => (
    is => 'rw',
    isa => 'Str',
    predicate => 'has_url',
);

has referer => (
    is => 'rw',
    isa => 'Str',
    default => '',
);

has agent => (
    is => 'rw',
    isa => 'Str',
    default => 'OpenData::BR'
);

1;

