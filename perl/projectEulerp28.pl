#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my $x=0;
my $y=0;
my $sum = 1;
my $index = 1;
my $max = 1001;
for(my $l = 1; $l <= ($max-1)/2; $l++) {
	$index+=2*$l;
	$sum +=$index;
	$index+=2*$l;
	$sum +=$index;
	$index+=2*$l;
	$sum +=$index;
	$index+=2*$l;
	$sum +=$index;
}

print "after $max layers, sum is $sum\n";