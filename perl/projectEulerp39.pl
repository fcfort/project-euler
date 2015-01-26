#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my %perims;

for (my $a=1; $a < 1000; $a++ ){
	for (my $b=$a; $b < 1000 ;$b++ ){
		my $c = sqrt($a*$a+$b*$b);
		if (isInteger($c) && $a+$b+$c < 1000 && $a*$a+$b*$b == $c*$c) {
			#print "$a $b $c\n";
			$perims{$a+$b+$c}++;
		}
	}
}

my $max = 0;
my $maxVal = 0;
for(sort keys %perims ) {
	print "Perim $_ has $perims{$_} combos\n";
	if  ($perims{$_} > $max ) {
		$max = $perims{$_};
		$maxVal = $_;
	}
}

print " Max combos is $maxVal\n";

sub isInteger {
	return ($_[0] == floor($_[0]));
}