
package OpenData::Get::Curl;

use Moose::Role;
with 'OpenData::Get::Base';

use LWP::Curl;

has obj => (
    is      => 'rw',
    isa     => 'Object',
    lazy    => 1,
    default => sub { LWP::Curl->new }
);

1;

