#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use Math::BigInt;

print isLychrelNumber(89);
my $count = 0;
for my $n( 0 .. 9999 ) {
	if ( ! isLychrelNumber($n) ) {
		print "$n is not Lychrel\n";
		$count++;
	}
}

print "Ans is $count\n";



sub isLychrelNumber {
	my $n = shift;
	my $bign = Math::BigInt->new($n);
	my $i = 1;
	while ( $i <= 50 ) {
		if($n == 4994) {
			print "$bign + ".reverse($bign)."\n";
		}
		$bign += reverse $bign;
		
		if ( $bign eq reverse $bign ) {
			if (  $i > 20) {
				print "Lychrality of $n is $bign at $i iterations\n";
			}
			return 1;
		}
		$i++;
	}
	return 0;
}