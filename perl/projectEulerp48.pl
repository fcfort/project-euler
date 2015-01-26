#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use Math::BigInt;


my $sum = Math::BigInt->new(0);
for ( 1 .. 1000) {
	my $x = Math::BigInt->new($_);
	my $y = Math::BigInt->new($_);	
	$sum += $x**$y;

}

print $sum;

my ($lastDigit) = $sum =~  m/(.{10})$/;

print "\nAnswer is $lastDigit\n";