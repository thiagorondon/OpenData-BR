#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use EGov::BR::Federal::PortalTransparencia;

my $opendata = new EGov::BR::Federal::PortalTransparencia->new;

$opendata->add_collections('CEIS', 'Convenios', 'Servidores');

my $data = $opendata->process('CEIS');

