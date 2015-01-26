#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
my $prod = 1;
for(my $i=10;$i<=99;$i++){
	for(my $j=10;$j<=99;$j++){
		if ($i != $j && $i< $j) {
			my @i = split(//,$i);
			my @j = split(//,$j);
	
			if ( $i[0]==$j[0] ) {				
				if($j[1] != 0 && $i[1]/$j[1] == $i/$j) {
					print "$i/$j\n";
					$prod *= $i[1]/$j[1];
				}
			} elsif( $i[1]==$j[0] ) {
				if($j[1] != 0 && $i[0]/$j[1] == $i/$j) {
					print "$i/$j\n";
					$prod *= $i[0]/$j[1];			
				}
			}
			elsif ($i[0]==$j[1] ) {
				if($j[0] != 0 &&$i[1]/$j[0] == $i/$j) {
					print "$i/$j\n";
					$prod *= $i[1]/$j[0];
				}
			}
			elsif ( $i[1]==$j[0] ) {
				if($j[1] != 0 &&$i[0]/$j[1] == $i/$j) {
					print "$i/$j\n";
					$prod *= $i[0]/$j[1];
				}
			}
		}
	}
}

print "Answer is denominator of $prod\n";