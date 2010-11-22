#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::Federal::PortalTransparencia;

my $filename;

if ( $ARGV[0] and -e $ARGV[0]) {
    $filename = $ARGV[0];
} else {
    print "Use. $0 [filename]\n";
    exit 1;
}

my $slurp = file($filename)->slurp;
my $config = JSON::XS->new->decode($slurp);



