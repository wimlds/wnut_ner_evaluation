#!/usr/bin/perl -w

use strict;

# usage: perl dovetail.pl <base data> <add on> ... <add on>

my@datasets = ();

foreach my$arg(0..$#ARGV){
    open(F, $ARGV[$arg]) or die "$ARGV[$arg]: $!";
    my@f=<F>;
    chomp@f;
    push@datasets,[ map { [ split(/\s+/, $_) ] } @f  ];
#    print STDERR "Read ".scalar(@{$datasets[-1]})."\n";
    close F;
}
#die;

foreach my$row(0..(scalar(@{$datasets[0]}) - 1)){
    my$base = $datasets[0]->[$row];
    if($base->[0]){
      print "$base->[0]\t";
      foreach my$ds(1..$#datasets){
        my$label="O";
        if($datasets[$ds]->[0]->[0]){
          #die "mismatch: $ds $row" unless $datasets[$ds]->[0]->[0] eq $datasets[0]->[$row]->[1];
          if($datasets[$ds]->[0]->[0] eq $datasets[0]->[$row]->[1]){
	      $label=$datasets[$ds]->[0]->[1];
	      shift@{$datasets[$ds]};
	  }else{
	      # error recovery
	      while($datasets[$ds]->[0]->[0] && !($datasets[$ds]->[0]->[0] eq $datasets[0]->[$row]->[1])){
		  shift@{$datasets[$ds]};
	      }
	      if($datasets[$ds]->[0]->[0]){
		  $label=$datasets[$ds]->[0]->[1];
		  shift@{$datasets[$ds]};
	      }
	  }
	} # else error recovery
        print "$label\t"; 
      }
      print "$base->[1]\n";
    }else{
      foreach my$ds(1..$#datasets){
        shift@{$datasets[$ds]};
      }
      print "\n";
    }
}

    


