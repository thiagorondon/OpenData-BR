#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../lib";

use OpenData::App::Getopt;
use OpenData::Runtime;

sub main {

    my $app = OpenData::App::Getopt->new_with_options();

    if ( !$app->_trait and !$app->collection ) {
        print "A lista de providers disponível é:\n\n";

        my %traits = %OpenData::App::Getopt::traits;
        foreach my $item ( keys %traits ) {
            print "   $item (" . $traits{$item} . ")\n";
        }
        print "\nUse: $0 --provider nome --collection name\n";
        exit(1);
    }

    my $opendata = new OpenData::Runtime->with_traits( $app->_trait )->new(
        debug              => $app->debug,
        current_collection => $app->collection,
        set_browser        => $app->browser,
    );

    $opendata->process;

}

main;

1;

