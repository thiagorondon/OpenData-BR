
package OpenData::Flow::Node::SQL;

use Moose;
extends 'OpenData::Flow::Node';

use SQL::Abstract;

my $sql = SQL::Abstract->new;

has 'table' => (
    is         => 'ro',
    isa        => 'Str',
    default    => 'table',
    required => 1
);

has '+process_item' => (
    default => sub {
        return sub {
            my ($self, $data) = @_;
            my ($insert, @bind) = $sql->insert($self->table, $data);
            # TODO: regex ?
            map { $insert =~ s/\?/'$_'/; } @bind;
            print $insert . "\n";
            }
    }
);

1;

