
use Test::More tests => 7;

use strict;

package Test::Collection;

    use Moose;

    with 'OpenData::Provider::Collection';

    has '+id' => ( default => 'test' );

    has '+extractor' => (
        lazy => 1,
        default => sub { 1 }
    );

    has '+transformer' => (
        lazy => 1,
        default => sub { 1 }
    );

    1;

package Test;

    use Moose;
    with 'OpenData::Provider';

    sub add_collection_test {
        my $c = Test::Collection->new;
        shift->add_collection($c);
    }

    1;

package main;

my $opendata = Test->new;

ok( $opendata );
ok( $opendata->can('collection') );
ok( $opendata->can('loader') );
ok( $opendata->can('add_collection') );
ok( $opendata->can('collection') );
ok( $opendata->can('process') );

ok( $opendata->add_collection_test );

