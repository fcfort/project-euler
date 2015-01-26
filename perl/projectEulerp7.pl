#!/usr/bin/perl.exe -w
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

$n = 1;
for ( 2 .. 1000000 ) {
	if ( isPrime( $_) ) {
		print $n++ . "th prime is $_\n";
		last if $n == 10002;
	}
}