#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

print combinations(52,5);

my $count = 0;
for my $i ( 1 .. 100 ){
	for my $j ( 1 .. 100 ){
		my $combs= combinations($i,$j);
		if( $combs > 1e6 ) {
			print "$i c $j has " .combinations($i,$j) . " combos\n";
			$count++;
		}
	}
}
print "Answer is $count\n";

sub combinations {
	my $n = shift;
	my $k = shift;
	my $prod = 1;
	for(my $i=0; $i <= $k-1; $i++ ) {
		$prod *= ($n-$i)/($k-$i);
	}
	return $prod;
}