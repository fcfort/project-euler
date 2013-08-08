#!perl
use strict;
use warnings;
use Data::Dumper;
use Set::Object;
use Math::Combinatorics;
use Algorithm::Permute;
use Benchmark ':hireswallclock';

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


my $t0 = Benchmark->new;
# ... your code here ...
#getAnagramPairs(\%wordLengthMap);
#findAnagrams ( ['caw','dog','mom','god','dgo']);
my $len = 5;
my $wordAnagrams = findAnagrams($wordLengthMap{$len});	
my $list = findAnagramSquares($len);
my $anagramPairs = findAnagrams($list);

print "Found ".scalar(@{$list})." squares:".join(',',@{$list})."\n";
print "Found ".scalar(@{$anagramPairs})." square anagram pairs:\n";
print "Found ".scalar(@{$wordAnagrams})." word anagrams:\n";

my $maxNum = 0;

for my $wordPair (@{$wordAnagrams}) {
	print $wordPair->[0],",",$wordPair->[1],"\n";
	my $posArray = getPositionalValues($wordPair->[0],$wordPair->[1]);
	my $reverseArray = getPositionalValues($wordPair->[1],$wordPair->[0],);
	
	for my $numPair (@{$anagramPairs}) {		
		my $numArray = getPositionalValues($numPair->[0],$numPair->[1]);
		my $numReverse = getPositionalValues($numPair->[1],$numPair->[0]);
		
		if ( arraysEqual($posArray,$numArray) ||
			arraysEqual($posArray,$numReverse) ||
			arraysEqual($reverseArray,$numArray) ||
			arraysEqual($reverseArray,$numReverse))
		{
			print "Found match ".$numPair->[0]." ".$numPair->[1]." ".$wordPair->[0]." ".$wordPair->[1]."\n";
			if ( $numPair->[0] > $maxNum ) {
				$maxNum = $numPair->[0];
			}
			if ( $numPair->[1] > $maxNum ) {
				$maxNum = $numPair->[1];
			}			
		}
	}	
}
print "Max square num is $maxNum\n";


my $t1 = Benchmark->new;
my  $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";

sub getPositionalValues {
	my ($a,$b) = @_;
	my @a_list = split (//,$a);
	my @b_list = split (//,$b);
	
	my @b_indices;
	A: for my $bi (0..$#b_list) {
		for my $ai (0..$#a_list) {
			if ( $a_list[$ai] eq $b_list[$bi] ) {
				push(@b_indices,$ai);
				next A;
			}
		}
	}
	#print "$a ".join(',',0..$#a_list)." $b indices: " . join(',',@b_indices)."\n";
	return \@b_indices;
}

sub findAnagramSquares {
	my $len = shift;
	my $p = new Algorithm::Permute([0..9], $len);
	my @list;
	print "Done making permutation iterator\n";
	
	my ($l,$secondToLastDigit,$isOdd,$num);
	while (my @res = $p->next) {
		next if ( $res[0] == 0 );		
		$l = $res[-1];
		$secondToLastDigit = $res[-2];
		$isOdd = $secondToLastDigit % 2;
		
		next unless (
			( ! $isOdd && ($l == 1 || $l == 4 || $l == 9) )
				||
			( $isOdd && $l == 6 )
				||
			( $secondToLastDigit == 0 && $l == 0 )
				|| 
			( $secondToLastDigit == 2 && $l == 5 )
		);
					
		$num = int(join('',@res));
		#print "Looking at $num\n";
		if ( sqrt($num) ==  int( sqrt($num)) ) {
			#print "Number with integer sqrt found " . join('',@res)," sl $secondToLastDigit$l \n";
			push(@list,$num);
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
	
	my ($wordA,$wordB);
  	my $comboIter = Math::Combinatorics->new(count => 2,data => $l);
  	while(my @nextCombo = $comboIter->next_combination){
		$wordA = $nextCombo[0];
		$wordB = $nextCombo[1];
		if ( isAnagram($wordA,$wordB) && $wordA ne reverse $wordB) {
			#print "Anagram found $wordA, $wordB\n";
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
	my $num = int(join('',@{$digitArray}));
	return ( sqrt($num)==int(sqrt($num)) );
}

sub arraysEqual {
	my $x = shift;
	my $y = shift;
	# must be same length
	if ( scalar(@{$x}) != scalar(@{$y}) ) {
		return 0;
	}
	# all sorted chars must match
	for ( 0 .. $#{$x} ) {
		if ( $x->[$_] != $y->[$_] ) {
			return 0;
		}
	}
	return 1;
}