#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use Math::BigInt;
use PE;

my $x =  Math::BigInt->new(94);
my $y =  Math::BigInt->new(98);
print digitalSum($x->bpow($y)) . "\n";
$x =  Math::BigInt->new(94);
$y =  Math::BigInt->new(98);
print "val " . $x->bpow($y) . "\n";

my $max = 0;
for my $x ( 1 .. 99  ) {
	for my $y ( 1..99 ) {
		my $a =  Math::BigInt->new($x);
		my $digSum = PE::digitalSum($a->bpow($y));
		if ( $digSum > $max) {
			$max = $digSum;
			print "new max is $max for num $x**$y\n";
		}
	}
	#print "digital sum of $n is ".PE::digitalSum($n). "\n";
}

sub digitalSum {
	my $n = shift;
	my $sum = 0;
	while ( length($n) ) {
		my $digit = chop($n);
		print "$sum += $digit\n";
		$sum += $digit;
	}
	return $sum;
}