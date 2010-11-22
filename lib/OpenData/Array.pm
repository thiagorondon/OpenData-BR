
package OpenData::Array;

use Moose;

has 'items' => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
    handles => {
        all     => 'elements',
        add     => 'push',
        map     => 'map',
        filter  => 'grep',
        find    => 'first',
        get     => 'get',
        join    => 'join',
        count   => 'count',
        has     => 'count',
        empty  => 'is_empty',
        sorted  => 'sort',
    },
);

no Moose;

1;


