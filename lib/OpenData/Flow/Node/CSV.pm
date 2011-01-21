
package OpenData::Flow::Node::CSV;

use Moose;
extends 'OpenData::Flow::Node';

use Text::CSV;
use Data::Dumper;

our $csv = Text::CSV->new;

has 'header' => (
    is         => 'ro',
    isa        => 'ArrayRef[Str]',
    default    => sub { [] },
    auto_deref => 1
);

has 'filehandle' => (
    is  => 'ro',
    isa => 'FileHandle', default => sub { \*STDOUT } 
);

has 'eol' => (
    is      => 'ro',
    isa     => 'Str',
    default => "\n"
);

sub BUILD {
    my ($self) = @_;
    $csv->print( $self->filehandle, [ map { utf8::upgrade( my $x = $_ ); $x } @{ $self->header } ] )
        if $self->header;
    print $self->eol;
}

has '+process_item' => (
    default => sub {
        return sub {
            my ($self, $data)= @_;
            $csv->print( $self->filehandle, [ map { utf8::upgrade( my $x = $_ ); $x } @{$data} ] );
            print $self->eol;
            }
    }
);

1;

