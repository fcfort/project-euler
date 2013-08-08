#!/usr/bin/perl.exe -w

$max = 2000000; #2,000,000
$sum=0;
for (0..$max ) {
	if (isPrime($_)) {
		$sum += $_;
		#print "$_ is prime, sum is $sum\n";
	}
}
print "$sum\n";
sub isPrime  {
	my $num = shift;	
	if ( $num == 0 ) { return 0; }
	if ( $num == 1 ) { return 0; }
	for (2 .. sqrt($num)) {
		if ( $num % $_  == 0 ){
			return 0;
		}
	}
	return 1;
}