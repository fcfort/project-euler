#!/usr/bin/perl.exe -w


for ( 1 .. 5 ) {
print "Starting goToCOpt $_\n";
print goToCOpt(0,0,$_) . "\n";
print "Finishing  goToCOpt $_\n";
}



sub goToSum {
	my $max = shift;	
	
	print "Starting $max\n";
	$pathCount = 0;
	print "goToC ";
	print goToC(0,0,$max);
	print "\n";
	print "goToCOpt ";
	print goToCOpt(0,0,$max);
	print "\n";	
	goTo(0,0,$max);

	
	print "For $max,we found $pathCount paths\n";
	#print "We found ".2*$pathCount ." paths\n";
}

sub goToCOpt {
	my $x = shift;
	my $y = shift;
	my $max = shift;
	
#	if ( $max == 1 ){return 2;}
#	elsif ( $max == 2 ) {return 6;}
#	elsif ( $max == 3 ) {return 20;}
#	elsif ( $max == 4 ) {return 70;}	
#	elsif ( $max == 5 ) {return 252;}
#	elsif ( $max == 6 ) {return 924;}
#	elsif ( $max == 7 ) {return 3432;}
#	elsif ( $max == 8 ) {return 12870;}
#	elsif ( $max == 8 ) {return 12870;}	
#	elsif ( $max == 9 ) {return 48620;}
#	elsif ( $max == 10 ) {return 184756;}
#	elsif ( $max == 11 ) {return 705432;}
#	elsif ( $max == 12 ) {return 2704156;}
#	elsif ( $max == 13 ) {return 10400600;}
#	elsif ( $max == 14 ) {return 40116600;}	
	#print "Pos is $x,$y\n";
	my $count = 0;
	if( $x == $max && $y == $max ) {
		#print "We found a path!\n";
		return 1;
	}

	if ( $x > $max || $y > $max) {
		return 0;
	}
	
	if ( $x != 0 && $y != 0 && $x == $y ) {
		print "Calling with $max - 1\n";
		return $count + goToCOpt(0,0,$max - $x);
	} else {
		return $count + 
			goToCOpt($x+1,$y,$max) + 
			goToCOpt($x,$y+1,$max);
	}
	# return $count + ;	
}


sub goToC {
	my $x = shift;
	my $y = shift;
	my $max = shift;
	#print "Pos is $x,$y\n";
	my $count = 0;
	if( $x == $max && $y == $max ) {
		#print "We found a path!\n";
		return 1;
	}

	if ( $x > $max || $y > $max) {
		return 0;
	}
	
	return $count + 
		goToC($x+1,$y,$max) + 
		goToC($x,$y+1,$max);
	# return $count + ;	
}

sub goTo { 
	my $x = shift;
	my $y = shift;
	my $max = shift;
	#print "Pos is $x,$y\n";

	if( $x == $max && $y == $max ) {
		#print "We found a path!\n";
		$pathCount++;
		return;
	}

	if ( $x > $max || $y > $max) {
		return;
	}
	
	goTo($x+1,$y,$max);
	goTo($x,$y+1,$max);	
}


