
package OpenData::Transformer;

use Moose::Role;

with 'OpenData::Identifiable';

requires 'transform';

1;

__END__


