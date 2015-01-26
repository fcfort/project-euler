#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

#A permutation is an ordered arrangement of objects. For example, 3124 is one possible permutation of the digits 1, 2, 3 and 4. If all of the permutations are listed numerically or alphabetically, we call it lexicographic order. The lexicographic permutations of 0, 1 and 2 are:
#
#012   021   102   120   201   210
#
#What is the millionth lexicographic permutation of the digits 0, 1, 2, 3, 4, 5, 6, 7, 8 and 9?
perm([],[0,1,2,3,4,5,6,7,8,9]);


sub perm {
	my $staticRef = shift;
	my $permRef = shift;
	my @static = @$staticRef;
	my @perm = @$permRef;

	#print "Perm is " . join(",",@static) . "+" . join(",",@perm) . "\n";	
	#print scalar(@perm);
	if ( @perm == 2 ) {
		#print "Two elements left: $perm[0],$perm[1] " . scalar(@perm) . "\n";
		#print "Perm1 is " . join(",",@static) . "," . join(",",@perm) . "\n";			
		#print "Perm2 is " . join(",",@static) . "," . join(",",reverse @perm) . "\n";				
		$G::count+=2;
		if ($G::count % 1000 == 0 ) {
			print $G::count - 1 . ": " . join(",",@static) . "," . join(",",@perm) . "\n";		
			print $G::count . ": " . join(",",@static) . "," . join(",",reverse @perm) . "\n";		
		}
		die if ( $G::count > 1000000);
		#perm([],\@perm);
	} else {
		for(my $i=0; $i < @perm; $i++ ) {
			my $el = splice(@perm,$i,1);
			#print "Permuting " . $el . " and " . join(",",@perm) . "\n";
			push(@static,$el);
			perm ( \@static , \@perm );
			pop(@static);
			push(@perm,$el);
			@perm = sort(@perm);
		}
	}

}

sub swap { 
	my @a = @_;
	die unless $#a == 1;
	my $temp = $a[0];
	$a[0] = $a[1];
	$a[1] = $temp;
	return @a;
}

sub factorial  {
	my $n = shift;
	my $factorial = 1;
	for my $j ( 2 .. $n ) {  #         // compute (n- 1)!
		$factorial *= $j;
	}
	return $factorial;
}

# lifted from http://en.wikipedia.org/wiki/Permutation
sub permutation  {
	my $k = shift;
	my $sref = shift;
	my @s = @$sref;
	
	my $n = $#s + 1; 
	my $factorial = 1;
	
	for my $j ( 2 .. $n-1 ) {  #         // compute (n- 1)!
		$factorial *= $j;
	}
	print "$n! = $factorial\n";
	
	for my $j (1 .. $n-1) {
		my $tempj = (floor($k / $factorial)) % ($n + 1 - $j);
		my $temps = $s[$j+ $tempj];
		print "\$i range is ".($j + $tempj)." to ".($j+1)."\n";
		for (my $i = $j + $tempj ; $i >= $j+1 ; $i-- ) {
			$s[$i] = $s[$i - 1];    #  // shift the chain right
	 	}
	 $s[$j] = $temps;
	 $factorial = floor($factorial / ( $n - $j) );
	}
	print join(',',@s);
	print "\n";
	return \@s;
 }