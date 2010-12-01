
use Test::More tests => 6;

use strict;

package Portal;

use Moose;
with 'OpenData::BR::Federal::PortalTransparencia::Base';

1;

package main;

my $obj = Portal->new;
ok($obj);
ok( $obj->can('_make_page_url') );
ok( $obj->can('page') );
ok( $obj->can('_total_page') );
ok( $obj->can('last_page') );
ok( $obj->can('turn_page') );

