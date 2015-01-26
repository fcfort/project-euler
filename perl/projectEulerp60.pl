#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use PE;

my $max = 1e3;

my @small = @PE::primes[0..1e2];
my @set;

my $checkPrimes = sub {
	my $a = shift;
	my $b = shift;
	return (PE::isPrime($a.$b) && PE::isPrime($b.$a));
};


for (my $i = 0; $i < @small; $i++) {
	@set = ($small[$i]);
	print "Checking prime $small[$i]\n";
	for (my $j = $i + 1; $j < @small; $j++) {
		print "Pushing $small[$j] on to ".join(',',@set)."\n";
		push (@set,$small[$j]);
		if ( ! comb ( \@set,2,$checkPrimes ) ) {
			pop(@set);
		} else {
			for (my $k = $j + 1; $k < @small; $k++) {			
				print "Pushing $small[$k] on to ".join(',',@set)."\n";			
				push (@set,$small[$k]);
				if ( ! comb ( \@set,2,$checkPrimes ) ) {
					pop(@set);
				} else {	
					for (my $l = $k + 1; $l < @small; $l++) {
						print "Pushing $small[$l] on to ".join(',',@set)."\n";								
						push (@set,$small[$l]);
						if ( comb ( \@set,2,$checkPrimes ) ) {
							print "Found set: ".join(',',@set)."\n";
						}
					}
				}		
			}
		}
	}
}
 die;


for (my $i = 0; $i < @small; $i++) {
	push (@set,$small[$i]);
	print "Checking prime $small[$i]\n";
	for (my $j = $i + 1; $j < @small; $j++) {
		push (@set,$small[$j]);
		if ( ! comb ( \@set,2,$checkPrimes ) ) {
			pop(@set);
		} else {
			for (my $k = $j + 1; $k < @small; $k++) {			
				push (@set,$small[$k]);
				if ( ! comb ( \@set,2,$checkPrimes ) ) {
					pop(@set);
				} else {	
					for (my $l = $k + 1; $l < @small; $l++) {
						push (@set,$small[$l]);
						if ( ! comb ( \@set,2,$checkPrimes ) ) {
							pop(@set);
						} else {														
							for (my $m = $l + 1; $m < @small; $m++) {
								push (@set,$small[$m]);
								if ( comb ( \@set,2,$checkPrimes ) ) {
									print "Found set: ".join(',',@set)."\n";
								}
							}
						}
					}
				}		
			}
		}
	}
}

sub comb {
	my $set = shift;
	my $n = @$set;
	my $k = shift;
	my $callBackFunction = shift;
	my @subset = 0..$k-1;

	my $returnValue = 0;

	$returnValue = $callBackFunction->( map { $$set[$_] } @subset );
	
	while ($returnValue && nextCombination( \@subset , $n , $k ) ) {
		$returnValue = $callBackFunction->( map { $$set[$_] } @subset );
	}
	return $returnValue;
}


sub nextCombination {
	my $comb = shift;
	my $n = shift;
	#P1. Start of with (1, 2, …, k); this is the first combination.
	my $k = shift;
	my $i = $k - 1;
	#P2. Print it.
	# print join(',',@comb) . "\n";
	#P3. Given the combination (c0, c1, …, cn), start from the back and for ci, if it is larger than n - k + 1 + i then increment it and go on to the next indice i. After this, if c0 > n - k, then this is not a valid combination so we stop. Otherwise give ci+1, ci+2, … the values of ci + 1, ci+1 + 1, …. Jump to P2.
	++$$comb[$i];	
	
	#print join(',',@$comb) . "\n";
	#print "Is " . $$comb[$i] . " >= ". ($n - $k + 1 + $i) . "?\n";
	while($i > 0 && ($$comb[$i] >= $n - $k + 1 + $i) ) {
		--$i;
		++$$comb[$i];
		#print "Incrementing \$comb[$i] to $$comb[$i]\n";
	}
	
	if ( $$comb[0] > $n - $k ) {
		#print "It's over!\n";
		return 0;
	}
		
	for ( $i=$i+1; $i < $k; ++$i ) {
		$$comb[$i] = $$comb[$i - 1] + 1;
	}
	return 1;
} 