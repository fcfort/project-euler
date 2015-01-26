#!/usr/bin/perl.exe -w

$max = 1000;


LOOP: for my $a ( 1..1000) {
	print "Looking at $a\n";
	for my $b ( $a ..1000 ) {
		for my $c ( $b..1000 ) {
			if (
				$a+$b+$c == 1000 && 
				$a < $b && 
				$b < $c && 
				$a*$a + $b*$b == $c*$c
				) 
			{
				print "$a + $b + $c == 1000\n Soln is ".($a*$b*$c)."\n";
				last LOOP;
			}
		}
	}
}