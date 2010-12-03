
use Test::More tests => 4;

use strict;

use_ok( 'OpenData::BR::Federal::PortalTransparencia::CEIS');

use OpenData::BR::Federal::PortalTransparencia::CEIS;

my $obj = OpenData::BR::Federal::PortalTransparencia::CEIS->new;
ok($obj);

my $content = $obj->extract;
ok($content);

my $data = $obj->transform($content);
ok($data);
