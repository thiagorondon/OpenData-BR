
package OpenData::Output::CSV;

use Moose::Role;
use Text::CSV;
use POSIX;

our $csv = Text::CSV->new;

sub add { 
    my $self = shift;
    my $data = shift;

    my @cols;
    foreach my $item (@{$data}) {
        push ( @cols, $item->{$_} ) for keys %{$item};
    }

    print $csv->print( *STDOUT_FILENO, \@cols );
    print "\n";
}

1;

