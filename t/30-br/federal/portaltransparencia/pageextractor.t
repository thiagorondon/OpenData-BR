
use Test::More tests => 13;

use strict;
use Cwd;

use_ok('EGov::BR::Federal::PortalTransparencia::PageExtractor');

use EGov::BR::Federal::PortalTransparencia::PageExtractor;

my $pe = EGov::BR::Federal::PortalTransparencia::PageExtractor->new(
    baseURL => 'file://' . getcwd(),
    mainURI => 'examples/ceis-page.html'
);

ok($pe);
can_ok( $pe, '_make_page_url' );
can_ok( $pe, '_total_page' );
can_ok( $pe, 'turn_page' );
can_ok( $pe, 'extract' );

ok( $pe->URL eq 'file://' . getcwd() . '/' . 'examples/ceis-page.html' );
ok( $pe->_make_page_url(42) eq $pe->URL . '?Pagina=42' );

# for magic numbers, refer to examples/ceis-page.html
ok( $pe->last_page == 354 );

ok( $pe->turn_page == 1 );
ok( $pe->page == 1 );

ok( $pe->page(354) == 354 );

eval { $pe->page(400); };
ok($@);

