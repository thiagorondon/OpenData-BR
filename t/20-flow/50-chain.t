
use Test::More tests => 10;

package Repeat;
use Moose;
extends 'OpenData::Flow::Node';
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

use OpenData::Flow::Node;
use OpenData::Flow::Node::Chain;
use common::sense;

# tests: 3
my $uc = OpenData::Flow::Node->new(
    name         => 'UpperCase',
    process_item => sub { shift; return uc(shift) }
);
ok($uc);
my $rv = OpenData::Flow::Node->new(
    name         => 'Reverse',
    process_item => sub { shift; return reverse $_[0]; }
);
ok($rv);
my $chain = OpenData::Flow::Node::Chain->new( links => [ ( $uc, $rv ) ] );
ok($chain);

#use Data::Dumper;
#diag( Dumper($chain) );
#diag( Dumper($chain->chain) );

# tests: 2
ok( !defined( $chain->process() ) );

#print STDERR '=' x 70 . "\n";
my $abc = $chain->process('abc');

#use Data::Dumper; diag( 'abc = ' ,$abc );
ok( $abc eq 'CBA' );

# tests: 3
my $rp5 = Repeat->new( times => 5 );
ok($rp5);
my $cc =
  OpenData::Flow::Node->new( process_item => sub { shift; return length(shift) }
  );
ok($cc);
my $chain2 = OpenData::Flow::Node::Chain->new( links => [ $rp5, $cc ] );
ok($chain2);

# tests: 2
$chain2->input( 'qwerty', 'yay' );

#use Data::Dumper; diag( Dumper($chain) );
my $thirty = $chain2->output;

#use Data::Dumper; diag( Dumper($thirty) );
ok( $thirty == 30 );

#use Data::Dumper; diag( Dumper($chain2) );
my $fifteen = $chain2->output;

#use Data::Dumper; diag( Dumper($fifteen) );
ok( $fifteen == 15 );

