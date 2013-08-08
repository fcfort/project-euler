#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use Algorithm::Permute;

my @primes = @{readPrimes()};
print "Done loading primes\n";

my %primes;
for my $prime (@primes ) {
	my @digits = split (//,$prime);
	my $p = new Algorithm::Permute(\@digits);
	my @primePermList;
	while (my @res = $p->next) {
    	my $num = join('',@res);
    	if ( isPrime($num) ) {
    		#print "Permutation found! $num for $prime\n";
			push(@primePermList,$num);    		
    	}
    	
	}
	
	for my $perm (@primePermList) {
		$primes{$prime}{$perm} = 1;
	}
}

my $count = 0;
for my $prime ( sort keys %primes ) {
	if ( keys %{$primes{$prime}} >= 4 ) {
		# let's find difference between all numbers in prime list
		my @primeList = keys %{$primes{$prime}};
		@primeList = reverse sort {$a<=>$b} (@primeList) ;
		#print join(',',@primeList) . "\n";
		my @diffs;
		my %diffs;
		for (my $i=0; $i < @primeList ;$i++) {
			for (my $j=$i+1; $j < @primeList ;$j++) {
				my $diff = $primeList[$i] - $primeList[$j];
				push(@diffs,$diff);
				$diffs{$diff}++;
				if ($diffs{$diff} >= 2) {
					if ($diff ==3330 && ($prime != 1487 || $prime != 4817 || $prime != 8147)) {
						print join(',',@primeList) . "\n";
						print "$prime with diff $diff ! \n";				
					}
				}
			}
		}
		#print "Diffs " . join(',',sort {$a<=>$b} @diffs) . "\n";
	}
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

sub readPrimes {
	# loads primes less than 1e6 plus one more
	my $file = "primes4digit.txt";
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


sub perm {
	my $staticRef = shift;
	my $permRef = shift;
	my @static = @$staticRef;
	my @perm = @$permRef;

	if ( @perm == 2 ) {		
		$G::count+=2;
		my $cycle = 100000;

		my $perm1 = join("",@static) . join("",@perm);		
		my $perm2 = join("",@static) . join("",reverse @perm);
		PERM: for my $perm( $perm1,$perm2) {
			my $offset = 0;
			PRIME: for my $by ( 2,3,5,7,11,13,17 ) {
				$offset++;
				my $subset = substr($perm,$offset,3);
				print "$perm\n";
				print "Dividing $subset by $by\n";
				if ( ! isDivisibleBy ($subset,$by) ) {
					#print "$perm div by $by\n";
					next PERM;
				}					
			}
			print "$perm has pandigital property\n";	
			#$sum+=$perm;
		}
		if ($G::count % $cycle == 0 ) {
			print $perm1 .  "\n";;
		}	
	} else {
		for(my $i=0; $i < @perm; $i++ ) {
			my $el = splice(@perm,$i,1);
			push(@static,$el);
			perm ( \@static , \@perm );
			pop(@static);
			push(@perm,$el);
			@perm = sort(@perm);
		}
	}
}