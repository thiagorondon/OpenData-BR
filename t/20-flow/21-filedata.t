use Test::More tests => 10;

use_ok('OpenData::Flow::Node::FileData');
new_ok('OpenData::Flow::Node::FileData');

my $data = OpenData::Flow::Node::FileData->new( initial_data => [ './examples/filedata.test' ] );

#use Data::Dumper;
#diag(Dumper( $data ));
#diag(Dumper( $data->output ));
#my $res = $data->output;
#diag( 'res = '.$res );
ok( $data->output eq 'linha 1' );
ok( $data->output eq 'linha 2' );
ok( $data->output eq 'linha 3' );
ok( $data->output eq 'linha 4' );
ok( $data->output eq 'linha 5' );
ok( $data->output eq 'linha 6' );
ok( $data->output eq 'linha 7' );

ok( ! defined( $data->output ) );
#ok( !( $data->output ) );

#eval { $data->input('more input') };
#ok( !$@ );
#ok( !( $data->output ) );

