#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Acme::Comment;
use Math::BigRat;
my $maxX = 0;
my $maxVal = 0;
DLOOP: for my $D ( 1..1000 ) {
	if (! PE::isSquare($D) ) {
		print "$D: ".join(',',getSqrtAs($D,10)) ."\n";
		
		my $h_ref = [0,1];
		my $k_ref = [1,0];
		my $a0 = floor(sqrt($D));
		my @coeffs = ($a0,$a0,1,$D);
		
		
		for ( 1..200 ) {
			my $a_n = $coeffs[0];	
			#print "$D: a_$_ is $a_n f\n";
			( $h_ref, $k_ref) = getNextConvergent($a_n, $h_ref, $k_ref);
			my $h = Math::BigInt->new(@$h_ref[$#$h_ref]);
			my $k = Math::BigInt->new(@$k_ref[$#$k_ref]);
			
			#print "h, k are $h, $k pell approx=" .($h*$h - $D*$k*$k)."\n";
			if ( $h*$h - $D*$k*$k == 1 ) {
				#print "\t\tFound pell-type approximation = ".($h*$h - $D*$k*$k)."\n";
				print "Minimal solution for $D is $h after $_ iterations\n";
				if ( $h > $maxX ) {
					$maxX = $h;
					$maxVal = $D;
					print "New max $h\n";
				}
				next DLOOP;
			}
			@coeffs = getNextSqrtA(@coeffs); 			
		}
		die "No minimal soln for $D found after 200 iterations\n";
	}
}
print "max X found was $maxX for D = $maxVal\n";


sub getSqrtAs {
	my $sqrtNum = shift;
	my $numAs = shift;
	
	my $a0 = ( floor(sqrt($sqrtNum)) );
	my @coeffs = ($a0,$a0,1,$sqrtNum);
	my @a = ($a0);
	for ( 0 .. $numAs ) {
		@coeffs = getNextSqrtA(@coeffs);
		push(@a,$coeffs[0]); 
	}
	return @a;
}


sub getNextSqrtA {
	my $a = shift;
	my $b = shift;
	my $c = shift;
	my $sqrt = shift;
	
	my $c_new = ($sqrt - $b**2)/$c;
	#print "a' before floor (sqrt($sqrt) + $b)/$c_new) = ".((sqrt($sqrt) + $b)/$c_new)."\n";
	my $a_new = floor((sqrt($sqrt) + $b)/$c_new);
	my $b_new = $a_new*$c_new - $b;	
	#print "New $a_new $b_new $c_new $sqrt\n";
	return ($a_new,$b_new,$c_new,$sqrt);
}


sub getNextConvergent {
	my $a_n_temp = shift;
	my $h_ref = shift;
	my $k_ref = shift;

	my @h = @{$h_ref};
	my @k = @{$k_ref};

	my $n = @h;
	
	my $a_n = Math::BigRat->new($a_n_temp);
	my $h_n = $a_n*$h[$n-1] + $h[$n-2];
	my $k_n = $a_n*$k[$n-1] + $k[$n-2];
	
	push(@h,$h_n);
	push(@k,$k_n);
	#print "num is $h_n, den is $k_n now\n";
	return (\@h,\@k);
}