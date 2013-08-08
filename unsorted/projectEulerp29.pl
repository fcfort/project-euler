#!/usr/bin/perl -w
use strict;
use Math::BigInt;

my %s;
my $ub = 100;

for ( my $i=2; $i<= $ub ; $i++) {
	print "On $i\n";
	for(my $j=2; $j<=$ub; $j++ ) {
		my $x = Math::BigInt->new($i);
		my $y = Math::BigInt->new($j);
		$s{$x->bpow($j)} = 1;
		$s{$y->bpow($i)} = 1;
	}
}

#print "Values " . join(',',sort{$a<=>$b}keys(%s)) . "\n";
print "Results " . keys(%s) . "\n";