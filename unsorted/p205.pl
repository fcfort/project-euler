#!perl
use strict;
use warnings;
use Data::Dumper;
use Math::BigRat;
use Math::BigInt;
#Problem 205
#06 September 2008
#
#Peter has nine four-sided (pyramidal) dice, each with faces numbered 1, 2, 3, 4.
#Colin has six six-sided (cubic) dice, each with faces numbered 1, 2, 3, 4, 5, 6.
#
#Peter and Colin roll their dice and compare totals: the highest total wins. The result is a draw if the totals are equal.
#
#What is the probability that Pyramidal Pete beats Cubic Colin? Give your answer rounded to seven decimal places in the form 0.abcdefg

my $peter = diceFunc(4,9);
my $sum=0;
for ( 9..4*9) {
	my $prob = $peter->($_);
	$sum+=$prob;
	#print "4d4 prob for k=$_ is $prob\n";
}
#print "total prob is $sum\n";

$sum=0;
my $colin = diceFunc(6,6);
for ( 6..6*6) {
	my $prob = $colin->($_);
	$sum+=$prob;
	#print "6d6 prob for k=$_ is $prob\n";
}
#print "total prob is $sum\n";

my $p = diceFunc(4,9);
my $c = diceFunc(6,6);

my $totalProb = 0;
# for all peter options
for my $P ( 9..4*9 ) {	
	my $P_prob = $p->($P);
	for my $C ( 6..6*6 ) {
		if ( $P > $C ) {
			my $C_prob = $c->($C);
			$totalProb += $C_prob*$P_prob;
		}
	}
}
print "total prob is $totalProb\n";
print "Total prob rounded to seven places is ".$totalProb->as_float(7),"\n";

sub diceFunc {
	#  For i s-sided dice
	my ($s,$i) = @_;
	#print "$s $i\n";
	return sub {	
		my $k = shift;	
		if ( $k < $i || $k > $i*$s) {
			return 0;
		}	
		#print "s $s i $i k $k\n";
		my $f = Math::BigRat->new;
		my $max_n = Math::BigRat->new ( ($k - $i)/$s );
		$max_n->bfloor();
		#print "max n is $max_n\n";
		for my $n ( 0 .. $max_n ) {
			my $bin_1 = Math::BigRat->new($i);
			my $bin_2 = Math::BigRat->new($k - $s*$n - 1);
			#print "bin_1: $bin_1 over $n\n";
			bnok($bin_1,$n);
			bnok($bin_2,$i - 1);			
			my $sign  = Math::BigRat->new((-1)**$n);
			#print "sign $sign bin_1 $bin_1 bin_2 $bin_2\n";
			$f += $sign * $bin_1 * $bin_2;
			#print "f is $f\n";
		}
		my $stemp = $s;
		return $f->bmul(Math::BigRat->new($stemp)->bpow(-$i));
	}
}


sub bnok {
	my ($n,$k) = @_;
	$k = Math::BigRat->new($k);
	#print "n $n k $k\n";
	#print $n->bfac."\n";	
	my $den = Math::BigRat->new($n->copy - $k->copy)->bfac * $k->bfac;
	#print "den $den\n";
	#print "after n $n k $k\n";
	return 	$n->bfac->bdiv($den);
}