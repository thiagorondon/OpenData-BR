
package OpenData::Transformer;

use Moose::Role;

has id => ( is => 'ro', isa => 'Str', required => 1, );
has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { ucfirst( shift->id ) },
);
has description => ( is => 'ro', isa => 'Str', );

requires 'transform';

1;

__END__


