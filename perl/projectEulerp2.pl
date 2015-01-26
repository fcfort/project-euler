#!/usr/bin/perl.exe -w

my $max = 4000000;
my $fib = 1;
my $fib2 = 2;
my $fibSum = 0;



while ($fibSum < $max ) {
	print $fib2 . "\n";
	if ( $fib2 % 2 == 0 ) {
		$fibSum += $fib2;
		print $fib2 . " is even\n";
	}
	my $temp = $fib2 + $fib;
	$fib = $fib2;
	$fib2 = $temp;
}

print "\nsum is $fibSum\n";