
package OpenData::Flow::Node::CSV;

use Moose;
extends 'OpenData::Flow::Node';

use Text::CSV;

our $csv = Text::CSV->new;

has '+process_item' => (
    default => sub {
        return sub {
            shift;
            my $data = shift;
            $csv->print( *STDERR,
                [ map { utf8::upgrade( my $x = $_ ); $x } @{$data} ] );
            print "\n";
          }
    }
);

1;

