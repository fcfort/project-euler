#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

for my $n ( 144 .. 1000000 ) {
	my $hex = $n*(2*$n-1);
	if ( isPentagonal($hex) ) {
		print "Answer: $hex\n";
		die;
	}
}	




sub isTriangular {
	my $n = shift;
	return isNatural((sqrt(8*$n + 1) - 1)/2);
}

sub isPentagonal {
	my $n = shift;
	return isNatural((sqrt(24*$n + 1) + 1)/6);
}

sub isHexagonal {
	my $n = shift;
	return isNatural((sqrt(8*$n + 1) + 1)/4);
}

sub isInteger {
	return ($_[0] == floor($_[0]));
}

sub isNatural {
	my $n = shift;
	return ($n > 0 && isInteger($n));
}