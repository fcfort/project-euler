#!perl
use strict;
use warnings;
use Data::Dumper;

#Problem 102
#12 August 2005
#
#
#Three distinct points are plotted at random on a Cartesian plane, for which -1000  x, y  1000, such that a triangle is formed.
#
#Consider the following two triangles:
#
#A(-340,495), B(-153,-910), C(835,-947)
#
#X(-175,41), Y(-421,-714), Z(574,-645)
#
#It can be verified that triangle ABC contains the origin, whereas triangle XYZ does not.
#
#Using triangles.txt (right click and 'Save Link/Target As...'), a 27K text file containing the co-ordinates of one thousand "random" triangles, find the number of triangles for which the interior contains the origin.
#
#NOTE: The first two examples in the file represent the triangles in the example given above.
#open (TRI,'<','triangles.txt');
open (TRI,'<','triangles2.txt');
my @tris;
my $n = 0;
for (<TRI>) {
	#if( $n == 150 ) {last;}
	$n++;

	chomp;
	my @nums = split /,/;
	for (@nums) {
		chomp;
		$_ = int;
	}
	
	push(@tris,[
		[$nums[0],$nums[1]],
		[$nums[2],$nums[3]],
		[$nums[4],$nums[5]]
	]);
}

my $numContainZero = 0;
my $numContainZeroByPoints = 0;
my $total = 0;
for my $tri (@tris) {
	print "Examining triangle $total\n";
	my @allPairs = (
		[$tri->[0],$tri->[1]],
		[$tri->[1],$tri->[2]],
		[$tri->[2],$tri->[0]]
	);
	my @allX = (
		$tri->[0][0],
		$tri->[1][0],
		$tri->[2][0]
	);
	my @allY = (
		$tri->[0][1],
		$tri->[1][1],
		$tri->[2][1]
	); 
	#print Dumper($tri);
	my @intersectData;
	for my $pair (@allPairs) {
		my @p = @{$pair};
		my $xint;
		my $yint;
		if ( isSlopeZero(@p) ) {
			$yint = $p[0][1];
			if ( $yint == 0 ) {
				$xint = 'all';
			} else {
				$xint = 'none';
			}
			
		} elsif ( isSlopeUndefined(@p) ) {
			$xint = $p[0][0];
			if ( $xint == 0 ) {
				$yint = 'all';
			} else {
				$yint = 'none';
			}
			#print "X-int: ".getXint($x,$y)." Y-int". getYint($x,$y)."\n";
		} else {
			$xint = getXint(@p);
			$yint = getYint(@p);
			#print "X-int: ".." Y-int". getYint($x,$y)."\n";
		}
		print "($total) For (".$p[0][0].",".$p[0][1].") (".$p[1][0].",".$p[1][1]."), X-int: $xint Y-int $yint\n";	
		push(@intersectData,[$xint,$yint]);
	}
	
	
	if ( intersectsAllAxes (\@intersectData ) ) {
		print "YES Xs: ".join(",",@allX). " Ys: ".join(",",@allY)." ($total)\n";	
		$numContainZero++;
	} else {
		print "NO  Xs: ".join(",",@allX). " Ys: ".join(",",@allY)." ($total)\n";
	}
	if ( intersectsAllAxesByPoints (\@allPairs ) ) {
		print "YES by pts Xs: ".join(",",@allX). " Ys: ".join(",",@allY)." ($total)\n";	
		$numContainZeroByPoints++;
	} else {
		print "NO  by pts  Xs: ".join(",",@allX). " Ys: ".join(",",@allY)." ($total)\n";
	}	
	
	$total++;
}

print "$numContainZero ($numContainZeroByPoints) out of $total triangles contain zero\n";

sub getSlope {
	my $a = shift;
	my $b = shift;
	return ($a->[1] - $b->[1])/($a->[0] - $b->[0]);
}

sub getYint {
	my $a = shift;
	my $b = shift;

	if ( $a->[1] == $b->[1]) {
		return $a->[1];
	} else {
		my $m = getSlope($a,$b);
		return -$m*$b->[0] + $b->[1];
	}
}

sub getXint {
	my $a = shift;
	my $b = shift;

	return -getYint($a,$b)/getSlope($a,$b);
}

sub isSlopeZero {
	my $a = shift;
	my $b = shift;

	return $a->[1] == $b->[1];	
}

sub isSlopeUndefined {
	my $a = shift;
	my $b = shift;

	return $a->[0] == $b->[0];
}

sub intersectsAllAxes {
	my $intData = shift;
	
	my %d = (
		'xneg' => 0,
		'xpos' => 0,
		'yneg' => 0,
		'ypos' => 0	
	);
	
	for my $line (@{$intData}) {
		my $xint = $line->[0];
		my $yint = $line->[1];
		#X
		if ( $xint =~ /all/) {
			$d{'xneg'}++;
			$d{'xpos'}++;
		} elsif ( $xint =~ /none/) {
		} elsif ( $xint < 0 ) {
			$d{'xneg'}++;
		} elsif ( $xint > 0 ) {
			$d{'xpos'}++;
		} elsif ( $xint == 0 ) {
			$d{'xneg'}++;
			$d{'xpos'}++;	
		}
		#Y
		if ( $yint =~ /all/) {
			$d{'yneg'}++;
			$d{'ypos'}++;
		} elsif ( $yint =~ /none/) {
		} elsif ( $yint < 0 ) {
			$d{'yneg'}++;
		} elsif ( $yint > 0 ) {
			$d{'ypos'}++;
		} elsif ( $yint == 0 ) {
			$d{'yneg'}++;
			$d{'ypos'}++;	
		}		
	}
	print Dumper \%d;
	
	if ($d{'xneg'} > 0 &&
		$d{'xpos'} > 0 &&
		$d{'yneg'} > 0 &&
		$d{'ypos'} > 0
	) {
		return 1;
	} else {
		return 0;
	}
	
}

sub intersectsAllAxesByPoints {
	my $allPairsRef = shift;

	my @allCrossings;
	for my $pair (@{$allPairsRef}) {
		my @p = @{$pair};
		my $crossListRef = getAxisCross($pair);
		push(@allCrossings,@{$crossListRef});
	}
	# filter dupes
	my %axesHash;
	for (@allCrossings) {
		$axesHash{$_} = 1;
	}
	@allCrossings = keys %axesHash;
	
	print "All crossings " . join(",",sort {$a cmp $b} @allCrossings) ."\n";
	
	return ($#allCrossings == 3);
}


sub getAxisCross {
	my $pair = shift;
	
	my @p = @{$pair};
	
	for my $point (@p ) {
		if ( $point->[0] == 0 && $point->[1] == 0) {
			print "Found origin\n";
			return ['xneg','xpos','yneg','ypos'];
		}
	}
	
	my @xs = ($p[0][0],$p[1][0]);
	my @ys = ($p[0][1],$p[1][1]);
	
	print "getAxisCross() examining ($p[0][0],$p[0][1]),($p[1][0],$p[1][1])\n";
	
	@xs = sort {$a <=> $b} @xs;
	@ys = sort {$a <=> $b} @ys;	
	
	print "\@xs ".join(',',@xs). " \@ys ".join(',',@ys) ."\n"; ;
	
	my @axesCrossings;
	# y-axis crossing	
	if ( $xs[0] <= 0 && $xs[1] >= 0 ) {	
		print "Found y cross\n";
		if ( $ys[0] >= 0 && $ys[1] > 0 ) { 		# ypos
			print "adding ypos\n";
			push(@axesCrossings,'ypos');
		} if( $ys[0] < 0 && $ys[1] <= 0 ) { #yneg
			print "adding yneg\n";
			push(@axesCrossings,'yneg');
		} if( $ys[0] == 0 && $ys[1] == 0 ) { #both
			print "adding both\n";	
			push(@axesCrossings,'ypos');
			push(@axesCrossings,'yneg');
		} if ( $ys[0]*$ys[1] < 0 ) { # y's have diff signs
		
		}
	}
	# x-axis crossing	
	if ( $ys[0] <= 0 && $ys[1] >= 0 ) {	
		print "Found x cross\n";	
		if ( $xs[0] >= 0 && $xs[1] > 0 ) { 		# xpos
			print "adding xpos\n";		
			push(@axesCrossings,'xpos');
		} if( $xs[0] < 0 && $xs[1] <= 0 ) { #xneg
			print "adding xneg\n";		
			push(@axesCrossings,'xneg');
		} if( $xs[0] == 0 && $xs[1] == 0 ) { #both
			print "adding both\n";
			push(@axesCrossings,'xpos');
			push(@axesCrossings,'xneg');
		}
	}

	return \@axesCrossings;
}


