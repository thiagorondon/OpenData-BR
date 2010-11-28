
use Test::More tests => 4;

use strict;

package Portal;

    use Moose;
    with 'OpenData::BR::Federal::PortalTransparencia::CEIS';

    1;

package main;

my $obj = new Portal;
ok($obj);

ok($obj->can('_run_ceis'));
ok($obj->can('_ceis_init'));
ok($obj->can('_ceis_parse_tree'));

