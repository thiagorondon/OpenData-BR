
use Test::More tests => 4;

use strict;

use_ok('EGov::BR::Federal::PortalTransparencia::Servidores');

use EGov::BR::Federal::PortalTransparencia::Servidores;

my $obj = EGov::BR::Federal::PortalTransparencia::Servidores->new;
ok($obj);

my $content = $obj->extract;
ok($content);

my $data = $obj->transform($content);
ok($data);

