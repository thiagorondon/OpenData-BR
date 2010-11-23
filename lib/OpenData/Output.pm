
package OpenData::Output;
use Moose;

with 'MooseX::Traits';
has '+_trait_namespace' => ( default => 'OpenData::Output' );

1;

