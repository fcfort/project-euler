#!/usr/bin/perl.exe -w
my $max = 0;
for my $a( 100...999){
	for my $b( 100..999) {
		$num = $a*$b;
		if ($num eq reverse $num) {
			if ($num > $max ) {
				$max = $num;
			}
		}
	}
}

print "\nmax is $max\n";