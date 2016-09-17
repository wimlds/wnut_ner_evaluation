#!/usr/bin/perl -w

# usage: perl ngram2token.pl 4 data/dev < results/4gram/dev4_feat.results

use strict;

my$NGRAM=shift;
my$tokenFile=shift;

print STDERR "n-gram: $NGRAM\n";
print STDERR "token file?: $tokenFile\n";

open(TOKENS,$tokenFile) or die "Need token file: $!";

my$PADDING="|";
my@current=();

while(<TOKENS>){
    chomp;
    if(m/^\s*$/){
	# ended tweet, process

	my@window = ($PADDING) x $NGRAM; # beginning padding
	my@windowLabels = ("O\tO") x $NGRAM;
	my@windowTokens = ("") x $NGRAM;

	my$currentPos = -1;
	my$currentChar = -1;
	my$readLabel="";

	# advance input ngram entries
	for(1..$NGRAM){
	    my$ignore=<STDIN>;
	}

	# advance window, then print
	while(1){

	    if($windowTokens[0]){
		#print $windowTokens[0]."\t";
		print $windowLabels[0]."\n";
	    }

	    shift@window;
	    shift@windowLabels;
	    shift@windowTokens;

	    if(($currentPos < 0) || ($currentChar == length($current[$currentPos]->[0]) - 1)){
		if($currentPos >= $#current){
		    if($window[0] eq $PADDING){
			#$readLabel = <STDIN>;
			last;
		    }else{
			push@window, $PADDING;
			push@windowLabels, "O $readLabel";
			push@windowTokens, "";
		    }
		}else{
		    $readLabel=<STDIN>;
		    die join(" ",map{$_->[0]}@current) unless $readLabel;
		    chomp($readLabel);
		    my@labels=split(/\s+/, $readLabel);
		    $readLabel = $labels[1];
		    die (join(" ",map{$_->[0]}@current) . " [[" . join("", @window)."]]") unless $readLabel;	    
		    
		    $currentChar=0;
		    $currentPos++;
		    push@window, substr($current[$currentPos]->[0],$currentChar,1);
		    push@windowLabels, $current[$currentPos]->[1]." $readLabel";
		    push@windowTokens, $current[$currentPos]->[0];
		}
	    }else{
		$readLabel=<STDIN>;
		die join(" ",map{$_->[0]}@current) unless $readLabel;
		chomp($readLabel);
		my@labels=split(/\s+/, $readLabel);
		$readLabel = $labels[1];
		die (join(" ",map{$_->[0]}@current) . " [[" . join("", @window)."]]") unless $readLabel;
		    
		$currentChar++;
		my$label = $current[$currentPos]->[1];
		push@window, substr($current[$currentPos]->[0],$currentChar,1);
		push@windowLabels, $label." $readLabel";
		push@windowTokens, "";
	    }
	    #$readLabel = <STDIN>;
	}
	print "\n";	   
	$readLabel=<STDIN>;
	@current=();
    }else{
	push@current, [ split(/\s+/,$_) ];
    }
}
