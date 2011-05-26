
use Test::More tests => 4;

use strict;

use_ok('EGov::BR::Federal::PortalTransparencia::CEIS');

use EGov::BR::Federal::PortalTransparencia::CEIS;

my $obj = EGov::BR::Federal::PortalTransparencia::CEIS->new;
ok($obj);

my $content = $obj->extract;
ok($content);

my $data = $obj->transform($content);
ok($data);
