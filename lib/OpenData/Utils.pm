
package OpenData::Utils;

sub class2suffix {
    my $class = shift;
    $class =~ s/^.*:://g;

    #    $class = lc($class);
    return $class;
}

1;

