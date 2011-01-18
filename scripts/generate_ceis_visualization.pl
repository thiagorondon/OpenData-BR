
use strict;
use warnings;

use Text::CSV;

my $header = <<HTML;
<!--
You are free to copy and use this sample in accordance with the terms of the
Apache license (http://www.apache.org/licenses/LICENSE-2.0.html)
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>Google Visualization API Sample</title>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
    google.load('visualization', '1', {packages: ['geomap']});

    function drawVisualization() {
        var data = new google.visualization.DataTable();
        data.addRows(NROWS);
        data.addColumn('string', 'Estado');
        data.addColumn('number', 'CEIS');
HTML

my $footer = <<HTML;

    var options = {};
    options['region'] = 'BR';
    options['dataMode'] = 'markers';
                                 
    var geomap = new google.visualization.GeoMap(
        document.getElementById('visualization'));
    geomap.draw(data, options);
    }
                                                     

    google.setOnLoadCallback(drawVisualization);
</script>
</head>
<body style="font-family: Arial;border: 0 none;">
<div id="visualization" style="width: 800px; height: 400px;"></div>
</body>
</html>


HTML

sub main {

    if ( !$ARGV[0] ) {
        print "Use: $0 <file.csv>\n";
        exit;
    }

    my $csv = Text::CSV->new( { binary => 1 } );
    open my $fh, '<', $ARGV[0] or die "Error: $!";
    my %count;

    while ( my $row = $csv->getline($fh) ) {
        my $state = $row->[6];
        next if !$state;
        next if $state eq '**';
        defined( $count{$state} ) ? $count{$state}++ : ( $count{$state} = 0 );

    }

    $csv->eof or $csv->error_diag();
    close $fh;

    my $loop = 0;
    my $content;
    foreach my $state ( keys %count ) {
        my $uf = $state;
        my $va = $count{$state};
        $content .= <<EOF;
    data.setValue($loop, 0, '$state');
    data.setValue($loop, 1, $va)
EOF
        $loop++;
    }

    $header =~ s/NROWS/$loop/g;

    print $header;
    print $content;
    print $footer;
}

main;

