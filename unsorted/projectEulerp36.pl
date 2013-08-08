#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
my $sum = 0;
for my $n ( 0..1000000 ) {
	if ( $n eq reverse $n ) {
		my $str = changeBase($n);
		if ($str eq reverse $str ) {
			print "$n and $str\n";
			$sum+=$n;
		}	
	}
}
print "Answer is $sum\n";

sub changeBase {
	my $n = shift;
	my $base = shift;
	if ( $n == 0 ) { return '0'; }
	if ( ! defined $base ) 
		{$base = 2;}
	
	my $baseStr = '';
	my $digit;
	while( $n != 0 ){
		$digit = $n % $base;
		#print "Digit found $digit\n";
		$n -= $digit;
		$n /= $base;
		$baseStr = $digit . $baseStr;
	}
	return $baseStr;
}