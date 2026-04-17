#!/usr/bin/perl

if (!defined $ARGV[0]) {
    print "\ncalc_density.pl <magic file>\n\n";
    exit;
}

open(FILE, $ARGV[0]) or die "Cannot open file $ARGV[0]!\n";

my $current_layer = "";
my %area_per_layer;
my $in_layer = 0;

# Filter for only m1, m2, poly
my %wanted = map { $_ => 1 } qw(
    metal1 metal2
    polysilicon rpoly pseudo_rpoly ntransistor ptransistor
);

my $side = 8300; # size of PadFrame84
my $box_area = $side * $side;

while (<FILE>) {
    # Detect new layer
    if (/<< (\S+)/) {
        $current_layer = $1;
        $in_layer = exists $wanted{$current_layer} ? 1 : 0;
        next;
    }

    # Rectangle parsing
    if ($in_layer && /rect/) {
        my ($junk, $x1, $y1, $x2, $y2) = split;
        my $w = abs($x1 - $x2);
        my $h = abs($y1 - $y2);
        my $area = $w * $h;

        $area_per_layer{$current_layer} += $area;
    }

    # Subcell check
    if (/^use/) {
        die "[ERROR] Flatten layout first.\n";
    }
}

close(FILE);

# Aggregate poly
my $poly_area = 0;
foreach my $l (qw(polysilicon rpoly pseudo_rpoly ntransistor ptransistor)) {
    $poly_area += $area_per_layer{$l} if exists $area_per_layer{$l};
}


# Compute and print output
print "Bounding Box Area = $box_area lambda^2\n\n";

foreach my $layer (qw(metal1 metal2)) {
    my $area = $area_per_layer{$layer} // 0;
    my $percent = ($area / $box_area) * 100;

    printf "%s:\tArea = %d\tDensity = %2.5f%\n",
        $layer, $area, $percent;
}
# Account for poly combined
my $poly_percent = ($poly_area / $box_area) * 100;
printf "%s:\tArea = %d\tDensity = %2.5f%",
    "poly", $poly_area, $poly_percent;