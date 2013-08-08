#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my @primes = @{readPrimes()};
#my $str = "hello";
#print lchop($str) . ' '.$str;
#die;
my $sum=0;
for (@primes) {
	if ( $_ < 10 ) {
		next;
	}
	#print "Checking $_\n";
	if (isTruncatablePrime($_) ) {
		print "$_ is truncatable prime\n";
		$sum+=$_;
	}
} 
print "Answer is sum = $sum\n";

sub isTruncatablePrime {
	#assume input is prime
	my $n = shift;
	my $r = $n;
	for (1 .. length($n) - 1 ) {
		chop($n);
		lchop($r);
		if ( ! isPrime($n) ) {
			return 0;
		}
		if ( ! isPrime($r) ) {
			return 0;
		}
	}
	return 1;
}

sub lchop {
	#chops from left side;
	my $ref = \$_[0];
	my $r = reverse(${$ref});
	my $letter = chop($r);
	${$ref} = reverse $r;
	return $letter;
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
		# Binary search
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


sub readPrimes {
	# loads primes less than 1e6 plus one more
	my $file = "primes1e6.txt";
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