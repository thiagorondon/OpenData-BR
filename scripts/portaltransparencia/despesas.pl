#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../../lib";

use Data::Printer colored => 0;

use DataFlow 1.111560;
use DataFlow::Proc;
use aliased 'DataFlow::Proc::HTMLFilter';
use aliased 'DataFlow::Policy::WithSpec';
use aliased 'EGov::BR::Federal::PortalTransparencia::Flows::DespesasN0';

my $despesas_n0 = DespesasN0->new;

my $ano = shift || eval { use DateTime; DateTime->now->year - 1 };

my $flow = DataFlow->new( [ $despesas_n0, ] );

$flow->input($ano);
my @res = $flow->flush;

p @res;

