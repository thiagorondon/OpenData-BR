
package OpenData::Loader;

use Moose::Role;

with 'OpenData::Identifiable';

has collection => ( is => 'rw', isa => 'OpenData::Provider::Collection' );

requires 'load';

42;
