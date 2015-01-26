#!/usr/bin/perl.exe -w

$max = 1000000;
$maxLen = 0;
$startingNum = 0;
for my $n ( 1 .. $max ) {
	$init = $n;
	$count = 0;
	while($n != 1 ) {
		if ( $n %2 == 0) {
			$n/=2;
		} else {
			$n = $n+$n+$n+1;
		}
		#print $n . " ";
		$count++;
	}
	if ( $count > 350 ) {
		if ( $count > $maxLen ) {
			$maxLen = $count;
			$startingNum = $init;
			print "New max found ($maxLen) with $startingNum\n";
		}
	print "$init: $count\n";
	}
}

print $maxLen;