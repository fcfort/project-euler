#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Algorithm::Permute;
use Acme::Comment;
PE::readPrimes(1);
for my $n ( reverse 1..1e6 ) {
	my $phi = PE::eulerTotient($n);
	if ( PE::isPermutation($phi,$n) ) {
		print "phi($n) = ".PE::eulerTotient($n) . ", ratio is ".($n/$phi)."\n";
	}
	
	/*
	if ( $n % 1e6 == 0 ) {
		print "phi($n) = ".PE::eulerTotient($_) . "\n";
	}
	*/
}