#!/usr/bin/env perl

use FindBin qw($Bin);
use lib "$Bin/../lib";

use strict;
use warnings;

use Class::MOP;
use OpenData::App::Getopt;

our %providers = %OpenData::App::Getopt::providers;

sub help {
    print "\nUse: $0 --provider nome --collection name\n";
}

sub provider_list {
    print "A lista de providers disponível é:\n\n";
    foreach my $item ( keys %providers ) {
        print "   $item (" . $providers{$item} . ")\n";
    }
}

sub main {

    my $app = OpenData::App::Getopt->new_with_options();

    if ( !$app->provider and !$app->collection ) {
        &provider_list;
        &help;
        exit(1);
    } elsif ( !$providers{$app->provider} ) {
        print "Provider invalido.\n";
        &provider_list;
        &help;
        exit(2);
    }

    my $package = join('::', 'OpenData', $providers{$app->provider});
    eval { Class::MOP::load_class($package) };
    die "$@" if $@;

    my $opendata = $package->new;
    $opendata->add_collections($app->collection);
    $opendata->process($app->collection);

}

main;

1;

