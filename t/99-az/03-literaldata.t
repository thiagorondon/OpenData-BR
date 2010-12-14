
use Test::More tests => 4;

use_ok( 'OpenData::AZ::Box::LiteralData' );

eval { $fail = OpenData::AZ::Box::LiteralData->new };
ok($@);

my $data = OpenData::AZ::Box::LiteralData->new( data => 'aaa' );
#use Data::Dumper;
#diag(Dumper( $data ));
#diag(Dumper( $data->output ));
#my $res = $data->output;
#diag( 'res = '.$res );
ok( $data->output eq 'aaa' );
ok( !$data->output );

