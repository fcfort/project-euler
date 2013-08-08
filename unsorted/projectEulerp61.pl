#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use PE;
use Acme::Comment;
# Verifying figurate nums and tests
#for my $n( 1..1e6 ) {
#	for my $fig ( 3..8 ) {
#		if ( ! PE::isFigurateNumber($fig,PE::getFigurateNum($fig,$n)) ) {
#			print "Error on $n for $fig-ate num\n";
#		}
#	}	
#}
#print "Success up to 1e6\n";

#PE::readPrimes(2);

my %figArrays;
my %figTwoDigit;
my @figurates = (8,7,6,5,4,3);
#generate all 4 digit figurate nums
for my $fig ( 3..8 ) {
	print "Adding $fig - ate nums\n";
	my $n = 1;

	while ( PE::numDigits(PE::getFigurateNum($fig,$n)) < 5 ) {
		my $num = PE::getFigurateNum($fig,$n++);
		if ( PE::numDigits($num) == 4 ) {
			push (@{$figArrays{$fig}},$num);
			my ($twoDigit) = $num =~ /^([1-9][0-9])/;
			#print "Found 4 digit $fig-ate num $num with first two digits $twoDigit at index $#{$figArrays{$fig}}\n";
			push(@{$figTwoDigit{$fig}{$1}},$#{$figArrays{$fig}});
			
		}
	}
}

wrapRecurse();

/* 
for my $fig ( sort {$a<=>$b} keys %figTwoDigit ) {
	print "$fig-ate two digit beginnings indices:\n";
	for my $twodig ( keys %{$figTwoDigit{$fig}}) {
		print @{$figTwoDigit{$fig}{$twodig}};
	}
	print "\n";	
}
*/
/*
for my $fig ( sort {$a<=>$b} keys %figArrays ) {
	print "$fig-ate nums:\n";
	print join (',',@{$figArrays{$fig}});
	print "\n";
}
*/
#print Dumper(\%figArrays);
#print Dumper(\%figTwoDigit);

sub wrapRecurse {
	print "Starting recursion\n";
	for my $num ( @{$figArrays{8}} ) {
		my @newFigsLeft = (7,6,5,4,3);
		my @newFigList = ($num);
		#print "Recursing with figurates ".join(',',@newFigsLeft)." and set ".
		#	join(',',@newFigList) . "\n";
		recurse(\@newFigsLeft,\@newFigList);
	}
	
}	

sub recurse {
	my $figsLeft = shift;
	my $figList = shift;
	
	my $lastNum = $figList->[$#{$figList}];
	my $lastTwoDigitsOfNum = lastTwoDigits($lastNum);
	
	for my $fig ( @{$figsLeft} ) {
		my $lastTwoDigits = lastTwoDigits($lastNum);
		for my $i ( @{$figTwoDigit{$fig}{$lastTwoDigits}} ) {
			my @newFigsLeft;
			for ( @{$figsLeft} ) {
				if( $fig != $_ ) {
					push(@newFigsLeft,$_);
				}
			}
			my $newFigNum = $figArrays{$fig}[$i];
			my @newFigList = (@$figList,$newFigNum);
			if (@newFigsLeft == 0 && lastTwoDigits($newFigNum) eq substr($newFigList[0],0,2) ) {
				print "Recursing with figurates ".join(',',@newFigsLeft)." and set ".
				join(',',@newFigList) ." and sum ".PE::sum(@newFigList)."\n";
				return;
			}
			recurse(\@newFigsLeft,\@newFigList);
		}
	}
}
/*
for my $fig ( @figurates ) {
	for my $num ( @{$figArrays{$fig}} ) {

		for my $figTwoDigits ( @figurates ) {
			if ($figTwoDigits != $fig ) {
				my @indices = @{$figTwoDigit{$figTwoDigits}{$lastTwoDigits}};
				if ( ! @indices ) { 
					next;
				}
				for (@{$figTwoDigit{$figTwoDigits}{$lastTwoDigits}}) {
					
				}
			}
		}
	}
}
*/
sub lastTwoDigits {
	return substr($_[0],-2);
}
