
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
<div id="visualization" style="width: 600px; height: 750px;"></div>
</body>
</html>


HTML

my $header2 = <<HTML;
<html>
  <head>
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
    google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    function drawChart() {
    var data = new google.visualization.DataTable();
    data.addRows(NROWS);
    data.addColumn('string', 'Estado');
    data.addColumn('number', 'CEIS');

HTML

my $footer2 = <<HTML;
 var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
    chart.draw(data, {width: 750, height: 600, title: 'CEIS'});
}
</script>
</head>

<body>
<div id="chart_div"></div>
</body>
</html>

HTML

sub main {

    my ( $filename, $col, $template, $n_items ) = @ARGV;

    if ( !$filename and !$col ) {
        print "Use: $0 <file.csv> <col> [template] [n_items]\n";
        exit;
    }

    if ( !-r $filename ) {
        print "Unable to read file $ARGV[0]\n";
        exit;
    }

    if ( $col ne int($col) ) {
        print "<col> must be integer\n";
        exit;
    }

    if ( $template and $template != 1 and $template != 2 ) {
        print "[template] must be 1 or 2.\n";
        exit;
    }
    $template = 1 if !$template;

    my %stats = &get_hash_data( $filename, $col );

    my ( $loop, $content ) = &make_content($n_items, %stats);

    if ( $template == 1 ) {
        $header =~ s/NROWS/$loop/g;
        print $header, $content, $footer;
    }
    else {
        $header2 =~ s/NROWS/$loop/g;
        print $header2, $content, $footer2;
    }
}

sub get_hash_data {
    my $file = shift;
    my $col  = shift;

    my $csv = Text::CSV->new( { binary => 1 } );
    open my $fh, '<', $file or die "Error: $!";

    my %hash;

    while ( my $row = $csv->getline($fh) ) {
        my $value = $row->[$col];
        if ( $value and $value ne '**' ) {
            defined( $hash{$value} )
              ? $hash{$value}++
              : ( $hash{$value} = 1 );
        }
    }

    $csv->eof or $csv->error_diag();
    close $fh;

    return %hash;
}

sub make_content {
    my $n_items = shift;
    my %hash = @_;

    my $loop = 0;
    my $content;
    my $others = 0;
    foreach my $state ( sort { $hash{$b} <=> $hash{$a}} (keys(%hash)) ) {
        my $uf = $state;
        my $va = $hash{$state};

        if ($n_items and $n_items < $loop) {
            $others += $va;
            
        } else {
            $content .= <<EOF;
    data.setValue($loop, 0, '$state');
    data.setValue($loop, 1, $va)
EOF
        }
        $loop++;
    }

    if ($n_items and $others) {
        $loop = $n_items + 1; # fix for NROWS
        $content .= <<EOF;
    data.setValue($loop, 0, 'others');
    data.setValue($loop, 1, $others)
EOF
        $loop++; # fix for NROWS
    }

    return ( $loop, $content );
}

main;

