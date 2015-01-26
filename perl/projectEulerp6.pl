#!/usr/bin/perl.exe -w

my $sumOfSquares = 0;
my $sum = 0;
for my $i ( 1..100 ) {
	$sumOfSquares += $i*$i;
	$sum += $i;
}

my $diff = $sum*$sum - $sumOfSquares;
print "diff is $diff\n";