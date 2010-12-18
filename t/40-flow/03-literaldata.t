use Test::More tests => 7;

use_ok( 'OpenData::Flow::Box::LiteralData' );

eval { $fail = OpenData::Flow::Box::LiteralData->new };
ok($@);

my $data = OpenData::Flow::Box::LiteralData->new( data => 'aaa' );
#use Data::Dumper;
#diag(Dumper( $data ));
#diag(Dumper( $data->output ));
#my $res = $data->output;
#diag( 'res = '.$res );
ok( $data->output eq 'aaa' );
ok( !($data->output) );

eval { $data->input( 'more input' ) };
ok(!$@);
ok( !($data->output) );

$data = OpenData::Flow::Box::LiteralData->new( data => [ qw/oh my goodness/ ] );
is_deeply( $data->output, [ qw/oh my goodness/ ] );

