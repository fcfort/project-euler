#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Acme::Comment;
use Math::BigInt;
/*
use Algorithm::Permute;
use Math::Combinatorics;
use Benchmark qw(:all) ;
use diagnostics;
*/
#The 5-digit number, 16807=7**5, is also a fifth power. Similarly, the 9-digit number, 134217728=8**9, is a ninth power.
#
#How many n-digit positive integers exist which are also an nth power?

my $count = 0;
for (my $i=1; $i < 1000; $i++){
	my $n = 1;
	my $pow;
	do {
		my $x = Math::BigInt->new($n);
		# $pow = $n**$i;
		$pow = $x->bpow($i);
		if( PE::numDigits($pow) == $i ) {
			$count++;
			print "$n**$i = $pow (count is $count)\n";
			
		}
		$n++;
	} while( PE::numDigits($pow) <= $i )
}