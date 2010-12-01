
package OpenData::Loader;

use Moose::Role;

with 'OpenData::Identifiable';

requires 'load';

1;
