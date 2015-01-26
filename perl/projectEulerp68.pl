#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Algorithm::Permute;

my @p = (1..10);
my $maxString = 0;
Algorithm::Permute::permute { 
	if (  	($p[0]+$p[1]+$p[4] ==
			 $p[2]+$p[4]+$p[7])
		&&	
			($p[2]+$p[4]+$p[7] == 
			 $p[6]+$p[7]+$p[8]) 
		&&
			($p[6]+$p[7]+$p[8] == 
			 $p[3]+$p[6]+$p[9])
		&&
			($p[3]+$p[6]+$p[9] == 
			 $p[1]+$p[3]+$p[5]) 
		) {
			
			my %externalNodeIndices = (
				$p[0] => 0,
				$p[2] => 1,
				$p[8] => 2,
				$p[9] => 3, 
				$p[5] => 4
			);
			my @indices = sort {$a<=>$b} keys %externalNodeIndices;
			my $maxIndexKey = shift(@indices);
			my $maxIndex = $externalNodeIndices{$maxIndexKey};
			
			my @digitStrings = (
				$p[0].$p[1].$p[4],
				$p[2].$p[4].$p[7],
				$p[8].$p[7].$p[6],
				$p[9].$p[6].$p[3], 
				$p[5].$p[3].$p[1]
			);
			
			my @sortedStrings = sort { 
				my $a_temp = substr($a,0,1);
				if($a_temp eq '1' and substr($a,1,1) == 0) {
					$a_temp = 10;
				}
				my $b_temp = substr($b,0,1);
				if($b_temp eq '1' and substr($b,1,1) == 0) {
					$b_temp = 10;
				}	
				$a_temp <=> $b_temp;		
			} @digitStrings;
			
			
			print "Match found for @digitStrings\n";	
			print "Sorted as @sortedStrings\n";		
			my $digitString = '';
			for ( my $i = 0; $i < @digitStrings ; $i++) {
				$digitString .= $digitStrings[($i + $maxIndex) % scalar(@digitStrings)];
				print $digitStrings[($i + $maxIndex) % scalar(@digitStrings)] . " ";
			}
			print "\n";

			if (length($digitString) == 16 ) {
			
				print "$digitString, len is ".length($digitString)."\n";			
				if ( $digitString > $maxString ) {
					$maxString = $digitString;
				}
			}
		}
} @p;

print "Answer is $maxString\n";