#!/usr/bin/perl -w

# Usage: perl train_to_gram.pl 4 (bundle|separate) <  data/dev > data/dev_4gram

use strict;

my$NGRAM=shift;
my$bundle=shift;
$bundle = $bundle eq "bundle";

print STDERR "n-gram: $NGRAM\n";
print STDERR "bundle?: $bundle\n";

my$PADDING="|";
my@current=();

while(<STDIN>){
    chomp;
    if(m/^\s*$/){
	# ended tweet, process

	my@window = ($PADDING) x $NGRAM; # beginning padding
	#push@current, [ join("",@window), "O" ]; # end padding
	my@windowLabels = ("O") x $NGRAM;

	my$currentPos = -1;
	my$currentChar = -1;

	# advance window, then print
	while(1){
	    print join("",@window). "\t" . $windowLabels[0]."\n";

	    shift@window;
	    shift@windowLabels;

	    if(($currentPos < 0) || ($currentChar == length($current[$currentPos]->[0]) - 1)){
		if($currentPos >= $#current){
		    if($window[0] eq $PADDING){
			last;
		    }else{
			push@window, $PADDING;
			push@windowLabels, "O";
		    }
		}else{
		    $currentChar=0;
		    $currentPos++;
		    push@window, substr($current[$currentPos]->[0],$currentChar,1);
		    push@windowLabels, $current[$currentPos]->[1];
		}
	    }else{
		$currentChar++;
		my$label = $current[$currentPos]->[1];
		if(!$bundle){
		    $label=~s/^B/I/;
		}		
		push@window, substr($current[$currentPos]->[0],$currentChar,1);
		push@windowLabels, $label;	
	    }
	}
	print "\n";	   
	@current=();
    }else{
	push@current, [ split(/\s+/,$_) ];
    }
}
