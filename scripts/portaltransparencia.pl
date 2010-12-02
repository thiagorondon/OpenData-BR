#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::BR::Federal::PortalTransparencia;

#my $opendata = new OpenData::Runtime->new;
my $opendata = new OpenData::BR::Federal::PortalTransparencia->new;
$opendata->add_collection_servidores;
$opendata->add_collection_ceis;
$opendata->add_collection_convenios;

my $data = $opendata->process('servidores');

