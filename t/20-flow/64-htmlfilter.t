
use Test::More tests => 9;

BEGIN {
    use_ok('OpenData::Flow::Node::HTMLFilter');
}

my $fail = eval q{OpenData::Flow::Node::HTMLFilter->new};
ok($@);

my $filter1 = OpenData::Flow::Node::HTMLFilter->new(
    search_xpath => '//td',
    );
ok($filter1);

my $undef = $filter1->process();
ok( !defined( $undef ) );

my $html = <<EOH;
<html>
    <body>
        <table>
            <th>
                <th>A</th>
                <th>B</th>
                <th>C</th>
            </th>
            <tr>
                <td>a1 yababaga    </td>
                <td>b1 bugalu</td>
                <td>c1 potatoes</td>
            </tr>
        </table>
    </body>
</html>
EOH

$filter1->input($html);
my @res = $filter1->output;
ok( $res[2] eq '<td>c1 potatoes</td>' );

my $filter2 = OpenData::Flow::Node::HTMLFilter->new(
    search_xpath => '//td',
    result_type => 'VALUE',
    );
ok($filter2);

$filter2->input($html);
my @res2 = $filter2->output;
#use Data::Dumper; diag( 'res2 = '. Dumper(@res2) );
ok( $res2[2] eq 'c1 potatoes' );

my $filter3 = OpenData::Flow::Node::HTMLFilter->new(
    search_xpath => '//td',
    result_type => 'VALUE',
    ref_result => 1,
    );
ok($filter3);

$filter3->input($html);
my $res3 = $filter3->output;
#use Data::Dumper; diag( 'res3 = '. Dumper($res3) );
ok( $res3->[2] eq 'c1 potatoes' );

