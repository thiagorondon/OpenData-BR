#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::Runtime;

my $opendata = new OpenData::Runtime
    ->with_traits('BR::Federal::PortalTransparencia')->new;

my $data = $opendata->process;

print $opendata->transform($data);


