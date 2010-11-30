
package OpenData::Provider::Collection::Item;

use Moose::Role;
use OpenData::Provider::Collection;

with 'OpenData::Debug';

has id => ( is => 'ro', isa => 'Str', required => 1, );

has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { ucfirst( shift->id ) },
);

has description => ( is => 'ro', isa => 'Str', );

has collection =>
  ( is => 'rw', isa => 'OpenData::Provider::Collection', weak_ref => 1, );

has failed => ( is => 'ro', isa => 'Bool', writer => '_failed', );
has failing_fields =>
  ( is => 'ro', isa => 'ArrayRef[Str]', writer => '_failing_fields' );

##############################################################################

42;

