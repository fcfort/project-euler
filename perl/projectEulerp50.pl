#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use PE;

my $max = 231;

#initiate primes below a million
my @primes1e6;
for (my $i=0; $i < @PE::primes && $PE::primes[$i] < 1e6; $i++ ) {
	$primes1e6[$i] = $PE::primes[$i];
}

@PE::primes = @primes1e6;
print "Done copying primes\n";

my $p;
for (my $i=$#primes1e6; $i >= 0; $i--) {
	$p = $primes1e6[$i];
	#print "Checking $p\n";
	my @result = findConsecutivePrimeSum($p);
	if (@result > $max) {
		$max = @result;
		print "New max found for $p, max is $max\n";
		print "Sum is ". PE::sum(@result). "=". join('+',@result);
	}
}

print "Size of \@primes is ".@PE::primes."\n";

sub findConsecutivePrimeSum  {
	#assume prime
	my $n = shift;
	my $sum = 0;
	my @nums;
	for my $p ( @PE::primes ) {
		if ( $sum == $n ) {	
			#print "Found sum $sum=".join('+',@nums)."\n";
			return @nums;
		}
		if ( $p > $n ) {
			return ();
		}
		#print "Trying to fit $p (sum=$sum)\n";
		push(@nums,$p);
		$sum+=$p;
		while ( $sum > $n ) {
			my $remove = shift(@nums);
			$sum -= $remove;
			#print "Removing $remove, sum=$sum\n";
		}
	}
}