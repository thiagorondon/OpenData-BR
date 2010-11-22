#!/usr/bin/env perl

use Moose;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::Runtime;

my $opendata = new OpenData::Runtime
    ->with_traits('BR::Federal::PortalTransparencia')->new;

print $opendata->process;



