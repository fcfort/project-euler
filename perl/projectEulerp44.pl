#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

#makePentagonal(10000);
my @pentagonals = @{readPentagonalNumbers()};

#my $max = 1000;
#for ( my $i=0; $i < $max ;$i++) {
#	for ( my $j=$i+1; $i < $max ;$j++) {	
#	}
#}



for (my $i=0; $i <= $#pentagonals; $i++ ){
	my $a = $pentagonals[$i];
	print "Checking $a\n";
	for (my $j=$i; $j <= $#pentagonals; $j++ ){
		my $b = $pentagonals[$j];
		#print "$a and checking $b\n";		
		if ( isPentagonalCalc($a+$b) ) {
			
			if (isPentagonalCalc($b-$a)) {	
				print "$a $b diff (Answer) is ".($b-$a)."\n";
				die;
			}
		}
	}
}

sub makePentagonal {
	my $Pn = shift;
	for my $n ( 1..$Pn ) {
		my $pn = ($n*(3*$n - 1))/2;
		print $pn . "\n";
	}
}

sub isNatural {
	my $n = shift;
	return ($n > 0 && isInteger($n));
}

sub isPentagonalCalc {
	my $n = shift;
	return isNatural((sqrt(24*$n + 1) + 1)/6);
}

sub isPentagonal {
	die if not @pentagonals;
	my $n = shift;
	#throw-away non-integers
	if ( floor($n) != $n || $n < 0) {
		return 0;
	}
	if ( $n == 1 ){return 1;}
	if ( $n > $pentagonals[$#pentagonals] ) {
		#warn "Pent. num too big ($n)";
		return 0;
		
	} else {
		#Binary search
		my $l = 0;
		my $r = $#pentagonals + 1;
		my $p = floor(($r - $l)/2);
		while( $p != 0 ) {
			$p += $l;
			if ( $pentagonals[$p] < $n ) {
				#print "Lower bound set to $p\n";
				$l = $p;
			} elsif ( $pentagonals[$p] > $n ) {
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

sub readPentagonalNumbers {
	# loads first 1e4 pent nums
	my $file = "pentagonal1e4.txt";
	open(DATA, $file);
	my @data;
	for ( <DATA> )  {
		chomp;
		push(@data,$_);
	}
	return \@data;
}

sub isInteger {
	return ($_[0] == floor($_[0]));
}