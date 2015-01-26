#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Acme::Comment;
use Math::Big::Factors;
    use Benchmark qw(:all) ;
PE::readPrimes(1);
my %dmap;
my $dmax = 1e4;
$dmap{1} = 1;
print "Start loading divisors up to $dmax\n";
for my $d( 2 .. $dmax ) {
	print $d . "\n" if $d % 1e3 == 0;
	#print $d." -> " . PE::isSquareFree($d)."/".PE::eulerTotient($d)." = ".(PE::isSquareFree($d)/PE::eulerTotient($d))."\n";
	$dmap{$d} = PE::isSquareFree($d)/PE::eulerTotient($d);
}
print "Done loading divisors up to $dmax\n";
print PE::eulerTotient(36)."\n";
# max n thru 5e5 is 30030

my $max = 0;

my $start = 2;
my $end = 1e4;
my $interval = .1;
my $curInterval = $interval;
/*
for my $n ( $start..$end ) {

	if ( $n/$end >  $curInterval ) {
		$curInterval += $interval;
		print "" . floor(100*($n/$end))  . "%\n";
	}
	
	# my $ratio  = eulerTotientRatio($n);
	my $ratio = $sum;
	if ( $n % 1e4 == 0 ) {
		print "$n\t$ratio\n";
	}
	
	if ( $ratio > $max ) {
		print "new max $ratio for $n found\n";
		$max = $ratio;
	}
}
*/

 cmpthese(5, {
	'Name1' => &calcMax1,
	'Name2' => &calcMax2,
    });

sub calcMax1 {	
	my $start = 2;
	my $end = 1e4;
	my $interval = .1;
	my $curInterval = $interval;
	for my $n ( $start..$end ) {
		if ( $n/$end >  $curInterval ) {
			$curInterval += $interval;
			print "" . floor(100*($n/$end))  . "%\n";
		}
		
		my $ratio  = eulerTotientRatio($n);

		if ( $ratio > $max ) {
			print "new max $ratio for $n found\n";
			$max = $ratio;
		}
	}
}

sub calcMax2 {
	my $start = 2;
	my $end = 1e4;
	my $interval = .1;
	my $curInterval = $interval;
	for my $n ( $start..$end ) {
		if ( $n/$end >  $curInterval ) {
			$curInterval += $interval;
			print "" . floor(100*($n/$end))  . "%\n";
		}
		
		my $ratio  = eulerTotientRatioDivs($n);

		if ( $ratio > $max ) {
			print "new max $ratio for $n found\n";
			$max = $ratio;
		}
	}
}


sub eulerTotientRatioDivs {
	my $n = shift;
	my @divs = PE::getDivisors($n);
	my $sum = 0;
	for my $d (@divs) {
		#if ( $d == 1 ) {next;}
		if (defined $dmap{$d} ) {
			$sum += $dmap{$d};
		} else {
			warn "Cache miss on $d\n";
			$sum += PE::isSquareFree($d)/PE::eulerTotient($d);
		}	
	}
}

sub eulerTotientRatio {
	my $n = shift;
	my $p = PE::primeFactorization($n);
	my $prod = 1;
	# print Dumper($p);
	if ( keys (%$p) == 0 ) {
		return $n/($n - 1);
	}
	for my $prime (keys %$p) {
		# my $k = $p->{$prime};
		$prod *= (1 - 1/$prime);
	}
	return 1/$prod;
}