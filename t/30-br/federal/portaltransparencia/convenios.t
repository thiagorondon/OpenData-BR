
use Test::More tests => 4;

use strict;

use_ok('OpenData::BR::Federal::PortalTransparencia::Convenios');

use OpenData::BR::Federal::PortalTransparencia::Convenios;

my $obj = OpenData::BR::Federal::PortalTransparencia::Convenios->new;
ok($obj);

my $content = $obj->extract;
ok($content);

my $data = $obj->transform($content);
ok($data);

