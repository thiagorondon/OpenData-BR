
package OpenData::Array;

use Moose;


has set_output => (
    is => 'ro',
    isa => 'Str',
    default => 'Dumper'
);

has _output => (
    is  => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub { OpenData::Output->with_traits(shift->set_output)->new }
);

# Isto é apenas um hack para demonstrar a implementação que deve ser
# realizado com o Output.

sub add {
    my $self = shift;
    my $hash = shift;

    foreach ( keys %{$hash} ) {
        print "\"" . $hash->{$_} . "\"" . ";"
    }
    
    print "\n";
}

1;


__END__

has 'items' => (
    traits  => ['Array'],
    is      => 'ro',
    isa     => 'ArrayRef[HashRef]',
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


