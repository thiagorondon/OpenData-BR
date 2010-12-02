
package OpenData::Transformer::Null;

use Moose;

with 'OpenData::Transformer';

sub transform {
    return;
}

1;

