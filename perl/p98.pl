#!perl
use strict;
use warnings;
use Data::Dumper;
use Set::Object;
use Math::Combinatorics;
use Algorithm::Permute;

open WORDS,'<','words.txt';
my @words;
for (<WORDS>) {
	chomp;
	$_ =~ s/"//g;
	@words = split /,/;
}

#print scalar(@words);
my %wordLengthMap;
for ( @words ) {
	push(@{$wordLengthMap{length($_)}},$_);
}

getAnagramPairs(\%wordLengthMap);
#findAnagrams ( ['caw','dog','mom','god','dgo']);
my $list = findAnagramSquares(9);
findAnagrams($list);

sub findAnagramSquares {
	my $len = shift;
	my $p = new Algorithm::Permute([0..9], $len);
	my @list;
	print "Done making permutation iterator\n";
	while (my @res = $p->next) {
		if ( int($res[0]) != 0 ) {
			my $num = int(join('',@res));
			#print "Looking at $num\n";
			if ( sqrt($num) - int( sqrt($num)) == 0 ) {
				print "Number with integer sqrt found " . join('',@res),"\n";
				push(@list,$num);
			}
		}
	}
	return \@list;
}

sub getAnagramPairs {
	my $wordLengthMap = shift;
		for my $k ( sort {$a <=> $b} keys %{$wordLengthMap} ) {
		print "Words of length $k (".scalar(@{$wordLengthMap{$k}})."): ".join(',',@{$wordLengthMap{$k}}). "\n";
		findAnagrams($wordLengthMap{$k});	
	}
}

sub findAnagrams {
	my $listOfStringsRef = shift;
	my $l = $listOfStringsRef;
	
	my $len = scalar(@{$l});
	
	my @anagramPairs;
	
  	my $comboIter = Math::Combinatorics->new(count => 2,data => $l);
  	while(my @nextCombo = $comboIter->next_combination){
		my $wordA = $nextCombo[0];
		my $wordB = $nextCombo[1];
		if ( isAnagram($wordA,$wordB) && $wordA ne reverse $wordB) {
			print "Anagram found $wordA, $wordB\n";
			push(@anagramPairs,[$wordA,$wordB]);
		}
  	} 
  	return \@anagramPairs;
}

sub isAnagram {
	my $x = shift;
	my $y = shift;
	# must be same length
	if ( length ($x) != length($y) ) {
		return 0;
	}
	my @x_a = sort {$a cmp $b} split(m//,$x);
	my @y_a = sort {$a cmp $b} split(m//,$y);
	# all sorted chars must match
	for ( 0.. $#x_a ){
		if ( $x_a[$_] ne $y_a[$_] ) {
			return 0;
		}
	}
	return 1;
}

sub isSquare {
	my $digitArray = shift;
	my $num = int(join('',@{$digitArray));
	return ( sqrt($num)==int(sqrt($num)) )
}

sub isS