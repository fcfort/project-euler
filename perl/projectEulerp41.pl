#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my @primes = @{readPrimes()};
#primeSieve(100000000);
# perm([],[1,2,3,4,5,6,7]);
perm([],[7,6,5,4,3,2,1]);

sub perm {
	my $staticRef = shift;
	my $permRef = shift;
	my @static = @$staticRef;
	my @perm = @$permRef;

	if ( @perm == 2 ) {		
		$G::count+=2;
		my $cycle = 1;
		if ($G::count % $cycle == 0 ) {
			#print $G::count - 1 . ": " . join(",",@static) . "," . join(",",@perm) . "\n";		
			#print $G::count . ": " . join(",",@static) . "," . join(",",reverse @perm) . "\n";
			my $perm1 = join("",@static) . join("",@perm);		
			my $perm2 = join("",@static) . join("",reverse @perm);
			if (isPrime($perm1) ) {
				print $perm1. "\n";
				die;
			}
			if (isPrime($perm2) ) {
				print $perm2 . "\n";
				die;
			}			
		}
		die if ( $G::count > 1000000);
		#perm([],\@perm);
	} else {
		for(my $i=0; $i < @perm; $i++ ) {
			my $el = splice(@perm,$i,1);
			#print "Permuting " . $el . " and " . join(",",@perm) . "\n";
			push(@static,$el);
			perm ( \@static , \@perm );
			pop(@static);
			push(@perm,$el);
			@perm = sort(@perm);
		}
	}

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

sub primeSieve  {
	my $n = shift;
	my $sqrt = sqrt($n);
	my @a;
	for ( 2..$n ) {
		$a[$_] = $_;
	}
	#print join(',',@a);
	for (my $i=0; $i <= $sqrt; $i++ ) {
		my $strike = $a[$i];
		if ( defined $strike ) {
			#print "Striking $strike\n";
			for ( my $j=2*$strike;$j<=$#a;$j+=$strike) {
				$a[$j] = undef;
			}
		}
	}
	for (@a) {
		if(defined $_) {
			print "$_\n";
		}
	}
	#print join(',',@a);
}