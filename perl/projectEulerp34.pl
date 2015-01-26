#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

#145 is a curious number, as 1! + 4! + 5! = 1 + 24 + 120 = 145.
#
#Find the sum of all numbers which are equal to the sum of the factorial of their digits.
#
#Note: as 1! = 1 and 2! = 2 are not sums they are not included.


my @factorials = 		
	(1,1,2,6,24,120,720,5040,40320,362880,3628800,39916800,479001600,6227020800,87178291200,1307674368000,20922789888000,355687428096000,6402373705728000,121645100408832000,2432902008176640000);


for my $n (3..1000000 ) {
	my @digits = split(//,$n);
	my $sum = 0;
	for my $digit( @digits ) {
		$sum += factorial($digit);
	}
	#print "$n==$sum\n";
	if ($sum == $n){
		print "$n!\n";
	}
}



sub factorial {
	my $n = shift;
	if ($n > $#factorials ) {
		die;
	}
	return $factorials[$n];
}