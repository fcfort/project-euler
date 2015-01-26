#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my @digits=(1,2,3,4,5,6,7,8,9);

#perm([],[0,1,2,3,4,5]);

for my $n (1..10000) {
	my $mult=1;
	my $digits = '';
	#print "Checking $n\n";
	while(length($digits) < 9) {
		$digits .= $n*$mult++;
	}
	#print "$digits pandigital\n";
	if ( isPandigital ($digits ) ) {
		print "$n has pandigital products (Answer is largest $digits)\n"
	}
}

sub isPandigital {
	#defaults to pandigital-9 (i.e. 1,2,3,4,5,6,7,8,9)
	my $str = shift;
	my $numDigits = shift;
	if (! defined $numDigits ) {
		$numDigits = 9;
	}
	if (length($str) != $numDigits ) {
		return 0;
	}
	for ( 1 .. $numDigits ) {
		if ( $str !~ /$_/ ) {
			return 0;
		}
	}
	return 1;
}

sub perm {
	my $staticRef = shift;
	my $permRef = shift;
	my @static = @$staticRef;
	my @perm = @$permRef;

	if ( @perm == 2 ) {		
		$G::count+=2;
		my $cycle = 1;
		if ($G::count % $cycle == 0 ) {
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