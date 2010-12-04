use Test::More tests => 3;

use strict;

package OneL;

    use Moose;
    with 'OpenData::Loader';

    our @r;

    sub load {
        shift;
        push @r, @_;
    }

    sub result {
        shift;
        return wantarray ? @__PACKAGE__::r : $__PACKAGE__::r[0];
    }

    1;

package main;

my $obj = OneL->new;
ok($obj);
can_ok($obj, 'load');
ok($obj->load( 'anything') );
