#!/usr/bin/perl.exe -w

my $num = 600851475143; #  600,851,475,143

my @a;
$#a = $num;
my $i= 0;


for ( 2 .. $num ) {
	if ( $num % $_ == 0 ) {
		#print $_ . " is a factor\n";
		if (isPrime($_)) { 
			while ($num % $_ == 0) {
				$num/=$_;
				print "Removing $_. It's a prime factor\n";
			}
			print "Now we can try to factorize $num\n";
		}
	}
}


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