#!/usr/bin/perl.exe -w


multiples([3,5],1000);

sub multiples {
	my $arrayRef = shift;
	my $max = shift;

	#print @{$arrayRef};
	#print $max;	
	my $sum = 0;
	for my $val (2..$max-1) {
		for ( @$arrayRef ) {
			if ( $val % $_ == 0 ) {
				print $val . " ";
				$sum+=$val;
				last;
			}
		}
	}

	print "\nsum is $sum\n";
}