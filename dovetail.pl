#!/usr/bin/perl -w

use strict;

# usage: perl dovetail.pl <base data> <add on> ... <add on>

my@datasets = ();

foreach my$arg(0..$#ARGV){
    open(F, $ARGV[$arg]) or die "$ARGV[$arg]: $!";
    my@f=<F>;
    chomp@f;
    push@datasets,[ map { [ split(/\s+/, $_) ] } @f  ];
}

foreach my$row(0..(scalar($datasets[0]) - 1)){
    my$base = $datasets[0]->[$row];
    print "$base->[0]\t";
    foreach my$ds(1..$#datasets){
	die "mismatch: $ds $row" unless $datasets[$ds]->[$row]->[0] eq $datasets[0]->[$row]->[1];
	print $datasets[$ds]->[$row]->[1]."\t";
    }
    print "$base->[1]\n";
}

    


