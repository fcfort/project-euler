#!perl
use strict;
use warnings;
use Data::Dumper;

my %dir;
my %bouncyMap;
# 0 up
# 1 down
# 2 neither
for('00'..'99') {
	my @num = split(m//);
	if ( $num[0] > $num[1] ) {
		$dir{$_} = 1;
	}
	elsif ( $num[0] < $num[1] ) {
		$dir{$_} = 0;
	} else {
		$dir{$_} = 2;
	}
	print "$_ => $dir{$_}\n";
}
print "dirs map is done\n";

my $numBouncy = 0;
my $n = 1;
NWHILE: while ( $n < 2000	 ) {
	my $len = length($n); 
	print "Examining $n with len $len\n";
	if ( $len >= 3 ) {
		my $overallDir = 2;
		for my $offset ( 0..$len - 2) {		
			my $twoDigits = substr($n,$offset,2);
			print "Looking at $twoDigits of $n\n";
			my $currentDir = $dir{$twoDigits};
			
			if ( $overallDir != 2 && $currentDir != 2 &&
				$overallDir != $currentDir
			) {
				# number is bouncy
				my $exp = $len - ($offset + 2);
				my $incr = 10**$exp;
				print "Dir=$overallDir,cur=$currentDir. Bouncy at offset $offset for $n. Adding $incr.\n";
				$n += $incr;
				$numBouncy += $incr;
				
				#my $frac = ($numBouncy/$n)*1e6;
				#if ( int($frac) == $frac ) {
					print "frac is $numBouncy/$n=".($numBouncy/$n)."\n";
					die if (($numBouncy/$n) >= .99);
				#}
				next NWHILE;
			}			
			
			if ( $currentDir != 2 ) {
				#"Direction set to $overallDir\n";
				$overallDir = $currentDir;
			}
		}
	} 
	#my $frac = ($numBouncy/$n)*1e6;
	#if ( int($frac) == $frac ) {
		print "frac is $numBouncy/$n=".($numBouncy/$n)."\n";
		die if (($numBouncy/$n) > .99);
	#}
	$n++;
}
print "$n, num bouncy $numBouncy frac=".($numBouncy/$n)."\n";


sub isBouncy {
	my $n = shift;
	
	my @n = split(m//,$n);
	
	if ( @n == 1 || @n == 2) {
		return 0;
	}
	my $last = $n[0];
	
	my $dec = 1;
	my $inc = 1;
	
	for ( @n[1..$#n] ) {
		if ($_ > $last) {
			$dec = 0;		
		} 
		if ($_ < $last ) {
			$inc = 0;
		}		
		if ( $dec == 0 && $inc == 0 ) {
			return 1;
		}
		$last = $_;
	}	
	return 0;
}