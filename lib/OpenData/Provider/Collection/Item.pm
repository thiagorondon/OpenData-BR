
package OpenData::Provider::Collection::Item;

use Moose::Role;
use OpenData::Provider::Collection;

with 'OpenData::Identifiable';

has collection =>
  ( is => 'rw', isa => 'OpenData::Provider::Collection', weak_ref => 1, );

has failed => ( is => 'ro', isa => 'Bool', writer => '_failed', );
has failing_fields =>
  ( is => 'ro', isa => 'ArrayRef[Str]', writer => '_failing_fields' );

42;

