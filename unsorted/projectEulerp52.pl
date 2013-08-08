#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;


#print hasSameDigits('21214','11224');
#print hasSameDigits('21214','11142');

for ( 1 .. 1e6) {
#	if (hasSameDigits($_,2*$_) && hasSameDigits($_,3*$_)) {
#		print "$_ and ". 2*$_ . " and " . 3*$_ . " have same digits\n";
#	}
	if (hasSameDigits($_,2*$_) && hasSameDigits($_,3*$_) && hasSameDigits($_,4*$_) && hasSameDigits($_,5*$_) && hasSameDigits($_,6*$_)) {
		print "$_ and ". 2*$_ . " and " . 3*$_ . " and " . 4*$_ . " and " . 5*$_ . " and " . 6*$_ ." have same digits\n";
		die;
	}
}
sub hasSameDigits {
	my $stra = shift;
	my $strb = shift;
	
	if ( length($stra) != length($strb) ) {
		return 0;
	} else {
		return (join('',sort split(//,$stra)) == join('',sort split(//,$strb)) );
	}
}