#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
my $sumOfSum= 0;
for my $n ( 2..500000) {
	my @digits = split(//,$n);
	my $sum = 0;
	for my $digit (@digits) {
		$sum += $digit**5;
	}
	if ($n == $sum) {
		print "$n\n";
		$sumOfSum+=$sum;
	}	
}

print "answer: $sumOfSum\n";