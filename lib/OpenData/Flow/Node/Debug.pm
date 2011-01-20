
package OpenData::Flow::Node::Debug;

use Moose;
extends 'OpenData::Flow::Node';

use Data::Dumper;

has '+process_item' => (
    default => sub {
        return sub {
            my ($self, $data) = @_;
            print STDERR Dumper($data);
            return $data;
          }
    }
);

1;

