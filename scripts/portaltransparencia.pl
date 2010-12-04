#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::BR::Federal::PortalTransparencia;

my $opendata = new OpenData::BR::Federal::PortalTransparencia->new;

$opendata->add_collections('CEIS', 'Convenios', 'Servidores');

my $data = $opendata->process('CEIS');

