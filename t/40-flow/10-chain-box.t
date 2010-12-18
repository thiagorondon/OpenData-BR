
use Test::More tests => 10;

package Repeat;
    use Moose;
    extends 'OpenData::Flow::Box';
    has times => ( is => 'ro', isa => 'Int', required => 1 );
    has '+process_item' => (
        default => sub {
            return sub {
                my ( $self, $item ) = @_;
                return "$item" x $self->times;
            };
        }
    );

package main;

use OpenData::Flow::Box;
use OpenData::Flow::ChainBox;

# tests: 3
my $uc = OpenData::Flow::Box->new(
        process_item => sub { shift; return uc(shift) }
);
ok($uc);
my $rv = OpenData::Flow::Box->new(
        process_item => sub { shift; return reverse shift }
);
ok($rv);
my $chain = OpenData::Flow::ChainBox->new( chain => [ ( $uc, $rv ) ] );
ok($chain);

#use Data::Dumper;
#diag( Dumper($chain) );
#diag( Dumper($chain->chain) );

# tests: 2
my $undef = $chain->process();
ok( !$undef );

#print STDERR '=' x 70 . "\n";
#use Data::Dumper;
ok( $chain->process('abc') eq 'CBA' );

# tests: 3
my $rp5 = Repeat->new( times => 5 );
ok($rp5);
my $cc = OpenData::Flow::Box->new(
    process_item => sub { shift; return length(shift) } );
ok($cc);
my $chain2 = OpenData::Flow::ChainBox->new( chain => [ $rp5, $cc ] );
ok($chain2);

# tests: 2
$chain2->input('qwerty');
$chain2->input('yay');
ok( $chain2->output == 30 );
ok( $chain2->output == 15 );

