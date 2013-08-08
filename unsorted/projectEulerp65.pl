#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Acme::Comment;
use Math::BigRat;


for ( 100 ) {
	my @e_a = generateSequence($_);
	print "For $_, sequence is ".join(',',@e_a)."\n";
	my $e = Math::BigRat->new(1);
	my @h = (0,1);
	my @k = (1,0);
	my $n = 2;	
	for my $a_n_temp (@e_a) {
		my $a_n = Math::BigRat->new($a_n_temp);
		
		my $h_n = $a_n*$h[$n-1] + $h[$n-2];
		my $k_n = $a_n*$k[$n-1] + $k[$n-2];
		push(@h,$h_n);
		push(@k,$k_n);
				$n++;
		print "num is $h_n, den is $k_n. num sum is ".PE::digitalSum($h_n). "\n";
		
	}
	
	
}








sub generateSequence {
	my $numTerms = shift;
	my @vals = (2);
	my $k = 1;
	for (my $i = 1; $i < $numTerms; $i++ ) {
		my $val;
		if ( (($i+1)%3) == 0 ) {
			$val = 2*$k;
			$k++;
		} else {
			$val = 1;
		}
		push(@vals,$val);
	}
	return @vals;
}

