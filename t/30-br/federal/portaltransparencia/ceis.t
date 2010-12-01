
use Test::More tests => 3;

use strict;

use OpenData::BR::Federal::PortalTransparencia::CEIS;

my $obj = OpenData::BR::Federal::PortalTransparencia::CEIS->new;
ok($obj);

#ok($obj->can('_run_ceis'));
#ok($obj->can('_ceis_init'));
#ok($obj->can('_ceis_parse_tree'));

my $content = $obj->extract;

ok($content);

my $data = $obj->transform($content);

ok($data);
