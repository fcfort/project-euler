#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

#print isPandigital('9865327410',10);
my $sum = 0;
# perm([],[0,1,2,3,4,5,6,7,8,9]);
my @set = (1,2,3,4);
my $n = 10;
my $k = 3;
my @set2 = 0 .. $k - 1;

my $printCallBack = sub { print join('-',@_) . "\n"; };
comb(['Hi','Bob','Jim'],2,$printCallBack);


my @set10 = (0,1,2,3,4,5,6,7,8,9);

my $callBack2 = sub {
	my $num = join('',@_);
	
	if ( isDivisibleBy($num,2) ) {
		print "$num\n";
		my %nums;
		for ( 0..9) {
			$nums{$_} = 1;
		}
		for(@_) {
			$nums{$_} = 0;
		}
		my $newNum = $num;	
		for my $div ( 3,5,7,11,13,17 ) {
			lchop($newNum);					
			for my $digit ( keys %nums ) {
				if ( $nums{$digit} ) {
					my $testNum = $newNum . $digit;
					if (isDivisibleBy($testNum,$div)  ) {
						print "$testNum div by $div\n";	
						$nums{$digit} = 0;
						$newNum = $testNum;
					} else {
						return;
					}
				}
			}
		}
		print "Yay $num\n";
	}
};

comb(\@set10,3,$callBack2);


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
		my $cycle = 100000;

		my $perm1 = join("",@static) . join("",@perm);		
		my $perm2 = join("",@static) . join("",reverse @perm);
		PERM: for my $perm( $perm1,$perm2) {
			my $offset = 0;
			PRIME: for my $by ( 2,3,5,7,11,13,17 ) {
				$offset++;
				my $subset = substr($perm,$offset,3);
				print "$perm\n";
				print "Dividing $subset by $by\n";
				if ( ! isDivisibleBy ($subset,$by) ) {
					#print "$perm div by $by\n";
					next PERM;
				}					
			}
			print "$perm has pandigital property\n";	
			$sum+=$perm;
		}
		if ($G::count % $cycle == 0 ) {
			print $perm1 .  "\n";;
		}	
	} else {
		for(my $i=0; $i < @perm; $i++ ) {
			my $el = splice(@perm,$i,1);
			push(@static,$el);
			perm ( \@static , \@perm );
			pop(@static);
			push(@perm,$el);
			@perm = sort(@perm);
		}
	}
}

sub isDivisibleBy {
	my $n =shift;
	my $by = shift;
	if ( $n % $by == 0 ) {
		return 1;
	} else {
		return 0;
	}
}

sub comb {
	my $set = shift;
	my $n = @$set;
	my $k = shift;
	my $callBackFunction = shift;
	my @subset = 0..$k-1;
	
	$callBackFunction->( map { $$set[$_] } @subset );
	
	while ( nextCombination( \@subset , $n , $k ) ) {
		$callBackFunction->( map { $$set[$_] } @subset );
	}	
}


sub nextCombinationWrap {
	my $comb = shift;
	# so it passes the first element as a possible combo
	
	return \@set;
}

sub nextCombination {
	my $comb = shift;
	my $n = shift;
	#P1. Start of with (1, 2, …, k); this is the first combination.
	my $k = shift;
	my $i = $k - 1;
	#P2. Print it.
	# print join(',',@comb) . "\n";
	#P3. Given the combination (c0, c1, …, cn), start from the back and for ci, if it is larger than n - k + 1 + i then increment it and go on to the next indice i. After this, if c0 > n - k, then this is not a valid combination so we stop. Otherwise give ci+1, ci+2, … the values of ci + 1, ci+1 + 1, …. Jump to P2.
	++$$comb[$i];	
	
	#print join(',',@$comb) . "\n";
	#print "Is " . $$comb[$i] . " >= ". ($n - $k + 1 + $i) . "?\n";
	while($i > 0 && ($$comb[$i] >= $n - $k + 1 + $i) ) {
		--$i;
		++$$comb[$i];
		#print "Incrementing \$comb[$i] to $$comb[$i]\n";
	}
	
	if ( $$comb[0] > $n - $k ) {
		#print "It's over!\n";
		return 0;
	}
		
	for ( $i=$i+1; $i < $k; ++$i ) {
		$$comb[$i] = $$comb[$i - 1] + 1;
	}
	return 1;
} 

sub lchop {
	#chops from left side;
	my $ref = \$_[0];
	my $r = reverse(${$ref});
	my $letter = chop($r);
	${$ref} = reverse $r;
	return $letter;
}