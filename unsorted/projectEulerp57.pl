#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use Math::BigRat;
#use PE;

#It is possible to show that the square root of two can be expressed as an infinite continued fraction.
#
# sqrt 2 = 1 + 1/(2 + 1/(2 + 1/(2 + ... ))) = 1.414213...
#
#By expanding this for the first four iterations, we get:
#
#1 + 1/2 = 3/2 = 1.5
#1 + 1/(2 + 1/2) = 7/5 = 1.4
#1 + 1/(2 + 1/(2 + 1/2)) = 17/12 = 1.41666...
#1 + 1/(2 + 1/(2 + 1/(2 + 1/2))) = 41/29 = 1.41379...
#
#The next three expansions are 99/70, 239/169, and 577/408, but the eighth expansion, 1393/985, is the first example where the number of digits in the numerator exceeds the number of digits in the denominator.
#
#In the first one-thousand expansions, how many fractions contain a numerator with more digits than denominator?
my $x = Math::BigRat->new(300); 
my $y = Math::BigRat->new(423); 

#print $x/$y;
my @terms;
my $count = 0;

print continueFrac(1000) ."\n";

print "Answer is $count\n";


sub continueFrac {
	my $iter = shift;
	my $sum = Math::BigRat->new(0);
	my $one = Math::BigRat->new(1);
	my $two = Math::BigRat->new(2);	
	for  ( 1 .. $iter ) {
		#print "$_ iter\n";
		$sum = $one/($two + $sum);
		$sum += $one;
		push(@terms,$sum);
		#print "numerator " .$sum->numerator(). " denom " .$sum->denominator()."\n";
		if(numDigits($sum->numerator()) > numDigits($sum->denominator()) ) {
			$count++;
			print "for $sum, num digits > den digits, $count\n";		
		}
		$sum -= $one;
	}
	$sum += $one;
	return $sum;
}

sub numDigits {
	my $n = shift;
	return length($n);
}
