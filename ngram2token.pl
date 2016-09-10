#!/usr/bin/perl -w

use strict;

open(TOKENS,$ARGV[0]) or die "Need token file: $!";
my$ngram=$ARGV[1];

my@smoothedClasses=();
my@currentClassCounts = ();
my%classCounts=();
my@classPrevious=(0) x $ngram;

while(<STDIN>){
    chomp;
    if(m/^\s*$/){
        if(@currentClassCounts){
            my@currentSmoothedClass = ();
            for my$i(0..$#currentClassCounts){

    my%counts=();
    foreach my$i(1..$len){
        my$ngramRow = <STDIN>;
        my($gold,$predicted) = split(/\s+/, $ngramRow);
        if(!defined($counts{$predicted})){
            $counts{$predicted} = 1;
        }else{
            $counts{$predicted}++;
        }
    }
    my$maxClass = -1;
    my$maxCounts = -1;

    foreach my$predicted(keys %counts){
        my$counts = $counts{$predicted};
        if($counts > $maxCounts){
            $maxCounts = $counts;
            $maxClass = $predicted;
        }
    }
    if(maxCounts < 0){
        maxClass = "O";
    }
    print "$class $maxClass\n";
                
            
            
            push@smoothedClasses, [ @currentSmoothedClass ];
        }
        @currentSmoothedClass = ();
        %classCounts=();
        @classPrevious=(0) x $ngram;
        next;
    }
    
    
    

while(<TOKENS>){
    chomp;
    if(m/^\s*$/){
        print "\n";
        next;
    }
    my($tok,$class) = split(/\t/,$_);
    my$len=length($tok);
    my%counts=();
    foreach my$i(1..$len){
        my$ngramRow = <STDIN>;
        my($gold,$predicted) = split(/\s+/, $ngramRow);
        if(!defined($counts{$predicted})){
            $counts{$predicted} = 1;
        }else{
            $counts{$predicted}++;
        }
    }
    my$maxClass = -1;
    my$maxCounts = -1;

    foreach my$predicted(keys %counts){
        my$counts = $counts{$predicted};
        if($counts > $maxCounts){
            $maxCounts = $counts;
            $maxClass = $predicted;
        }
    }
    if(maxCounts < 0){
        maxClass = "O";
    }
    print "$class $maxClass\n";
}
