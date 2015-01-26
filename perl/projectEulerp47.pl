#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my @primes = @{readPrimes()};
print "Done loading primes\n";
my $min = 1;
my $max = 1e6;
my $count = 0;
my $consec = 4;

my $n = $min;
NUM: while($n < $max ) {
	#print "Checking $n pF:". join (',',keys %{primeFactorization($n)}) . "\n";
	my $num = $n;
	if ( distinctPrimeFactors($num) == $consec) {
		print "$num has $consec distinct prime factors\n";
		# Go behind
		
		# Start looking
		my $count = 0;
		my $start = 0;
		for ( $b = $num - $consec; $b <= $num+$consec; $b++ ) {
			
			if (distinctPrimeFactors($b) == $consec ) {
				$start = 1;
				$count++;
				if ( $count == $consec ) {
					print "Found $consec pfs @ $b\n";
					die "Answer $b - 3 = ".($b-3)."\n";
				}
			} elsif ( $start ) {
				$count = 0;
				$n = $b;
				last;
			}
		}
	}
	# $n = $num;
	$n+=$consec;
}

sub distinctPrimeFactors { 
	my $n = shift;
	return scalar(keys %{primeFactorization($n)});
}

sub primeFactorization {
	my $num = shift;
	my $origNum = $num;
	
	if ( isPrime ( $num ) ) { return {} };
	my %primeFactors;
	# print "$num: ";
	my $s = sqrt($num);
	# print "Finding primes of $num\n";
	
	for ( my $i=0; $i <= $#primes;  $i++  ) {
		my $pi = $primes[$i];
		# print "Checked new prime $pi\n";		
		while($num % $pi == 0) {
			$num /= $pi;
			if ( $origNum != $pi ) {
				# print "Adding prime $pi\n";
				$primeFactors{$pi}++;
			}
		}		
		if ( $num == 1 || $pi > $origNum/2) {
			# print "Stopping, all primes found ($num==1) or $pi > ".$origNum/2."\n";
			return \%primeFactors;
		}
	}	
	die "wrong place or $num too big\n";
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

sub sum {
	my $sum=0;
	for (@_ ) {
		$sum+=$_;
	}
	return $sum;
}


sub isPrime {
	my $n = shift;
	#throw-away non-integers
	if ( floor($n) != $n || $n < 0) {
		return 0;
	}
	if ( $n == 2 ){return 1;}
	if ( $n > $primes[$#primes] ) {
		warn "Prime too big ($n)";
		return 0;
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
