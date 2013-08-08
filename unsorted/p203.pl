#!perl
use strict;
use warnings;
use Data::Dumper;
use Math::BigInt;
use Set::Object;
my $t = Math::BigInt->new(3);
my $k = 2;
bnok($t,$k);
print "bnok = $t\n";
#die;

#mobius('121548660036300');

my $pascals = Set::Object->new;
my $maxRow = 50;
for my $n ( 0 .. $maxRow) {	
	for my $i( 0 .. $n/2 ) {
		#skip central binomial nums
		if ( $n > 8 && $n == 2*$i ) {
			print "Skipping ($n $i), never squarefree\n";
			next;
		}
		my $a = Math::BigInt->new($n);
		print "Calculating bnok($a,$i)=";
		bnok($a,$i);
		print "$a\n";
		#print "a_$i = ($n $i) = $a \n";
		# push(@pascals,$a);	
		$pascals->insert("$a");
	}
	#print "\n";
}

print "All #s to test: ".join(',',sort { $a <=> $b } $pascals->members)."\n";;


sub bnok {
	my ($n,$k) = @_;
	$k = Math::BigInt->new($k);
	my $den = Math::BigInt->new($n->copy - $k->copy)->bfac * $k->copy->bfac;
	return 	$n->bfac->bdiv($den);
}

sub mobius {
	my $n = shift;
	my @xa;
	for my $k ( 1 .. $n ) {
		my $gcd = Math::BigInt::bgcd($n,$k);
		if ( $gcd == 1 ) {
			push ( @xa,$k) ;
		}
	}
	print "k vals = ".join(',',@xa)."\n";
}