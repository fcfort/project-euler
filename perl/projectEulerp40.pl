#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my $n = 0;
my $digitIndex = 0;
my $prod = 1;
while ( $digitIndex <= 1000000 ) {
	$n++;
	#print "Checking $n\n";
	my $r = $n;
	for (  1.. length($n) ) {
		$digitIndex++;
		my $digit = lchop($r);
		#print "$digitIndex: $digit\n";
		if(	$digitIndex == 1 || 
			$digitIndex == 10 ||
			$digitIndex == 100 ||
			$digitIndex == 1000 ||
			$digitIndex == 10000 ||
			$digitIndex == 100000 ||
			$digitIndex == 1000000
		) { 
			print "DigitIndex $digitIndex: $digit\n";
			$prod *= $digit;
		}
	}	
}
print "Answer is $prod\n";



sub lchop {
	#chops from left side;
	my $ref = \$_[0];
	my $r = reverse(${$ref});
	my $letter = chop($r);
	${$ref} = reverse $r;
	return $letter;
}