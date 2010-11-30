
package OpenData::Output;
use Moose;

with 'OpenData::Loader';
with 'MooseX::Traits';
has '+_trait_namespace' => ( default => 'OpenData::Output' );

sub load {
    shift->add(@_);
}

1;

