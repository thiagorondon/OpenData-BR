
package OpenData::Flow::Node::Null;

use Moose;
extends 'OpenData::Flow::Node::NOP';

override 'input' => sub { };

1;

