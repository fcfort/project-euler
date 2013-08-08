#!perl
use strict;
use warnings;

package Factor;
use Math::GMP;
use Math::BigInt lib => 'GMP';
use Data::Dumper;
use Benchmark ':hireswallclock';

my $probab_prime_iterations = 25;
$G::trialDivisions = 10000;

sub factor {
	my $n = shift;
	my %factors;
	my $orig_num = $n;	
	
	do {
		my $factor = getTrialDivisionFactor($n);	
		$factors{$factor}++;
		$n/=$factor;
		#print $n . "\n";
	} while ( ! isPrime ( $n ) && $n != 1);
	
	if ( isPrime ( $n ) ) {
		$factors{$n}++;
	}
	
	if ( ! isPrime ( $orig_num ) && $orig_num != 1) {
		warn "$orig_num not completely factored\n";
	}
	
	# print "Are we done? n is $n\n";
	return \%factors;			
}

sub isCompleteFactorization {
	my $n = shift;
	my $factorMap = shift;
	
	my $numToTest = 1;
	for my $factor( keys %{$factorMap} ) {
		my $power = $factorMap->{$factor};
		if ( ! isPrime ($factor) ) {
			warn "$factor isn't prime for number $n\n";
			return 0;
		}
		$numToTest *= $factor**$power;
	}
	#print "Equal? $numToTest $n\n";
	return ($numToTest == $n);
}
          
sub getTrialDivisionFactor {
	my $n = shift;
	
	if ( $n % 2 == 0 ) {
		return 2;
	}
	
	my $bound = int(sqrt($n));
	my $mod;
	for ( my $iter = 3; $iter < $G::trialDivisions && $iter <= $bound; $iter+=2 ) {
		#print "Trying to divide by $iter\n";		
		do {
			$mod = $n % $iter;
			if ( $mod == 0 ) {
				return $iter;
			}
		} while ( $mod == 0 );
	}
	return $n;
}

sub trialDivision {
	my $n = shift;
	my $factors = shift;

	my $bound = int(sqrt($n));
	$bound++;
	
	if ( isPrime($n) ){
		$factors->{$n}++;
		return;
	}
	if ( $n % 2 == 0 ) {
		$factors->{2}++;
		$n/=2;
		#print "Found factor of 2, n is $n\n";		
	}
	for ( my $iter = 3; $iter < $G::trialDivisions && $iter <= $bound  ; $iter+=2 ) {
		#print "Trying to divide by $iter\n";
		my $mod;
		do {
			$mod = $n % $iter;
			if ( $mod == 0 ) {
				$n /= $iter;
				$factors->{$iter}++;
			}
		} while ( $mod == 0 );
		
		if ( isPrime($n) ) {
			$factors->{$n}++;
			return;
		}
	}
}                      
  
sub trialDivisionGMP {
	my $n = shift;
	my $factors = shift;

	$n = Math::BigInt->new($n);
	
	my $bound = $n->copy->bsqrt($n);
	$bound++;
	
	if ( isPrime($n) ){
		$factors->{$n}++;
		return;
	}
	if ( $n % 2 == 0 ) {
		$factors->{2}++;
		$n/=2;
		#print "Found factor of 2, n is $n\n";		
	}
	for ( my $iter = 3; $iter < $G::trialDivisions && $iter <= $bound  ; $iter+=2 ) {
		#print "Trying to divide by $iter\n";
		my $mod;
		do {
			$mod = $n % $iter;
			if ( $mod == 0 ) {
				$n /= $iter;
				$factors->{$iter}++;
			}
		} while ( $mod == 0 );
		
		if ( isPrime($n) ) {
			$factors->{$n}++;
			return;
		}
	}
} 
   
sub pollardRho {
	my $n = shift;
	my $factors = shift;

	my $comp = $n;
		
	while ( $comp != 1) {
		$comp = getPollardRhoFactor($n);
		$n/=$comp;
		$factors->{$comp}++;
	}
	
}
                      
sub getPollardRhoFactor {
	print "Calling pollardRho\n";
	my ($n) = @_;
	my $xk;
	my $x2k;
	my $diff;
	my $gcd;
	my $x0 = 2;
	my $bound;
	
	while ($n % 2 == 0) {
		return $n/2;
	}

	if ($n == 1) {
		return 1;
	}
	
	#my $test = Math::GMP::probab_prime($n,25);
	#print "Initial test, $n is probably prime, $test\n";
	if ( isPrime($n) ) {
		#print "Initial test, $n is definitely prime\n";
		return $n;
	}	

	while (1) {
		#print "Trying to factor $n with x0 = $x0\n";
		$x0++;
		$xk = $x0;
		$x2k = $x0;
		$bound = int(sqrt($n));	
		#print "Bound set to $bound\n";
		while ( $bound > 0 ) {
			
			$bound--;
			#print "Finding f($xk,$n) and f($x2k,$n)\n";
			$xk = f($xk,$n);
			$x2k = f($x2k,$n);
			$x2k = f($x2k,$n);			
			$diff = $x2k - $xk;
			#print "Difference is $diff\n";
			$gcd = Math::BigInt::bgcd($diff,$n);
			#print "gcd is $gcd, bound is $bound\n";

			#print "Final gcd is $gcd\n";
			if ( $gcd > 1 ) {
				#print "Found gcd > 1, dividing $n by $gcd\n";
				$n /= $gcd;
				if ( $n == 1 ) {
					print "n is 1\n";
					return 1;
				}
				if ( isProbablyPrime($n) ) {
					#print "$n probably prime\n";
					return $n;
				}			
				$bound = sqrt($n);	
				#print "Bound set to $bound\n";		
			}
		}
		
	}
	return 0;
	
	sub f {
		my $x = shift;
		my $n = shift;
		$x = $x*$x + 1;
		$x %= $n;
		return $x;
	}
}

sub isPrime {
	return (Math::GMP::probab_prime($_[0],$probab_prime_iterations) == 2);
}

sub isProbablyPrime {
	return (Math::GMP::probab_prime($_[0],$probab_prime_iterations) > 0);
}

1;
