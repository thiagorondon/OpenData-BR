
package OpenData;
use Moose;
use namespace::autoclean;
use JSON::XS;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

sub _build_config {
    my $filename = $ENV{OpenData_config};
    return {} if !-e $filename;

    return JSON::XS->new->decode( scalar file($filename)->slurp( chomp => 1 ) );
}

1;

