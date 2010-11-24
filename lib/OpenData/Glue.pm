
package OpenData::Glue;

use DBI;
use Moose;

has dbfile => (
    is => 'ro',
    isa => 'Str',
    default => '/tmp/glue.db'
);

has _connect => (
    is => 'ro',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $dbfile = $self->dbfile;
        return DBI->connect("dbi:SQLite:dbname=$dbfile", "", "");
    }
);

has table => (
    is => 'rw',
    isa => 'Str',
    default => 'ev'
);

sub ev_create {
    my $self = shift;
    my $table = $self->table;
    my $create = "CREATE TABLE $table (key CHAR (64) NOT NULL, value CHAR(64), op CHAR(5))";
    $self->_connect->do($create);
}

sub ev_get {
    my ($self, $key) = @_;
    return undef if !$key;
    
    my $table = $self->table;
    my $sth = $self->_connect->prepare("SELECT * from $table where key='$key'");
    $sth->execute;
    my $row = $sth->fetch;
    
    return $row ? $row->[1] : undef;
}

sub ev_save {
    my ($self, $key, $value, $op) = @_;
    $op ||= '==';
    return $self->ev_update($key, $value, $op) if $self->ev_get($key);
    return $self->ev_insert($key, $value, $op);
}

sub ev_update {
    my ($self, $key, $value, $op) = @_;
    my $table = $self->table;
    my $sth = $self->_connect
        ->prepare("UPDATE $table set value='$value' where key='$key'");
    return $sth->execute;
}

sub ev_insert {
    my ($self, $key, $value, $op) = @_;
    my $table = $self->table;
    my $sth = $self->_connect
        ->prepare("INSERT INTO $table VALUES ('$key', '$value', '$op')");
    return $sth->execute;
}


1;

