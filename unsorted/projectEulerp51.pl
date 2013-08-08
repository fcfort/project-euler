#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

#use PE;
findMatchingDigits(23443);
findMatchingDigits(333);
findMatchingDigits(223442);
#findMatchingDigits(144);
#findMatchingDigits(33144);
die;


my $max = 1e6;
my $p =0;
my $count=0;
for ( my $i=0; $i < @PE::primes && $PE::primes[$i] < $max; $i++)  {
	$p = $PE::primes[$i];
	# detects all numbers with two or more same digits 
	if ( $p =~ /(.).?.?.?\1/g ) {
		my $firstIndex = $-[0];
		my $lastIndex = $+[0] - 1;
		my @str = split(//,$p);
		$str[$firstIndex] = '*';
		$str[$lastIndex] = '*';
		my $pstr = join('',@str);
		my $len = length($p) ;
		# num to add to each var
		my $diff = 10**(($len - 1) - $lastIndex) + 10**(($len - 1) - $firstIndex);
		#print "$count: $p . $#- matches at $-[0], $+[0]\n";
		my $pzero = $p - $1*$diff;
		my $primeMultCount = 0;
		for my $mult ( 0 .. 9 ) {
			my $pnew = $pzero + $diff*$mult;
			if ( PE::isPrime($pnew) ) {				
				$primeMultCount++;
				#print "Found $primeMultCount so far for $p, Testing $pnew\n";
				if($primeMultCount ==  7) {
					print "Found $primeMultCount so far for $pstr ($p), Testing $pnew\n";
				}	

			}

		}
		$count++;
	}
}

sub findMatchingDigits  {
	my $str = shift;
	my @digits;
	while( $str =~ /./g ) {
	 	print "For $str num is $&, at position ", pos $str, "\n";
	 	$digits[$&]++;
	}
	for (@digits) {
		
	}
}