
package OpenData::Extractor;

use Moose::Role;

with 'OpenData::Identifiable';

has collection  => ( is => 'rw', isa => 'OpenData::Provider::Collection' );

requires 'extract';

1;
