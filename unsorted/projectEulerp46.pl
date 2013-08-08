#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
my $min = 14393;
my $max = 1e5;
my @primes = @{readPrimes()};
print "Done reading primes\n";

NUM: for ( my $n=3; $n < $max ;$n+=2 ){
	print "Checking $n\n";
	if ( $n % 1e3+1 == 0 ) {
		print "Checking $n\n";
	}
	if ( isPrime($n) ) {
		next;
	}
	
	for ( my $i=0; $primes[$i] < $n && $i<=$#primes; $i++ ){
		my $y = sqrt(($n - $primes[$i])/2);
		#print "$n = $primes[$i] + 2*$y^2\n";
		if ( isInteger ($y ) ) {
			# print " is $n\n";
			next NUM;
		}
	}
	die "Answer is $n\n";
}

sub isInteger {
	return ($_[0] == floor($_[0]));
}

sub readPrimes {
	# loads primes less than 1e6 plus one more
	my $file = "primes1e7.txt";
	#my $file = "tempPrimes.txt";
	open(DATA, $file);
	#my @file = <DATA>;
	my @data;
	for ( <DATA> )  {
		chomp;
		# print '-'.$_.'-';
		push(@data,$_);
	}
	return \@data;
}

sub isPrime {
	my $n = shift;
	#throw-away non-integers
	if ( floor($n) != $n || $n < 0) {
		return 0;
	}
	if ( $n == 2 ){return 1;}
	if ( $n > $primes[$#primes] ) {
		die "Prime too big ($n)";
	} else {
		#Binary search
		my $l = 0;
		my $r = $#primes + 1;
		my $p = floor(($r - $l)/2);
		while( $p != 0 ) {
			$p += $l;
			if ( $primes[$p] < $n ) {
				#print "Lower bound set to $p\n";
				$l = $p;
			} elsif ( $primes[$p] > $n ) {
				#print "Upper bound set to $p\n";
				$r = $p;
			} else {
				return 1;
			}
			$p = floor(($r - $l)/2);
		}
	}
	return 0;
}