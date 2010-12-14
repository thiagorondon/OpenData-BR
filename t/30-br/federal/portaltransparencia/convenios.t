
use Test::More tests => 4;

use strict;

use_ok('EGov::BR::Federal::PortalTransparencia::Convenios');

use EGov::BR::Federal::PortalTransparencia::Convenios;

my $obj = EGov::BR::Federal::PortalTransparencia::Convenios->new;
ok($obj);

my $content = $obj->extract;
ok($content);

my $data = $obj->transform($content);
ok($data);

