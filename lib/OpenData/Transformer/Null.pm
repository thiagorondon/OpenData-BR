
package OpenData::Transformer::Null;

use Moose;

has 'OpenData::Transformer';

sub transform {
    shift;
    return @_;
}

1;

