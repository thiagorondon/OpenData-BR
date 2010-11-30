
use Test::More tests => 3;

use strict;

package Portal;

    use Moose;
    with 'OpenData::BR::Federal::PortalTransparencia::Page';

    1;

package main;

my $obj = Portal->new;
ok($obj);
ok($obj->can('_page'));
ok($obj->can('_total_page'));

