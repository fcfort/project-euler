#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
no warnings "recursion";
my @coins = (1,2,5,10,20,50,100,200);
my $total = 0;
sumsTo(0,'',0);


print "Total is $total\n";



# Recursive method
sub sumsTo {
	my $val = shift;
	my $coinList = shift;
	my $lastCoinIndex = shift;
	if ($val > 200 ) {
		return;
	} elsif ($val == 200 ) {
		#print "Eureka $val ($coinList)!\n";
		$total++;
		if ( $total % 1000 == 0 ) {
			print $total." $coinList\n";
		}
		return;
	} else {
		for(my $i=$lastCoinIndex; $i <= $#coins; $i++) {
			my $coin = $coins[$i];
			#print "For $val, adding $_\n";
			sumsTo($coin+$val,$coinList .','.$coin,$i);
		}
	}
}

