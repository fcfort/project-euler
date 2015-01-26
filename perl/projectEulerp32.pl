#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;


#print isPandigital(1,2,3456789) . "\n";
#print isPandigital(1,2,3456789) . "\n";
#print isPandigital(1,2,3456789) . "\n";
#print isPandigital(1,2,3456789) . "\n";
#print isPandigital(9871,2,3456) . "\n";
#
#die;

my $p=0;
my $str =0;
my @strA;
my %ans;
for ( my $i=2; $i<50; $i++ ) {
	#print "Checking $i of 10000\n";
	for ( my $j =$i; $j<2000; $j++) {
		$p = $i*$j;
		if(isPandigital($p,$i,$j) ) {
			print "$i*$j=$p\n";
			$ans{$p} = 1;
		}
	}
}
print "Answer is ".sum(keys(%ans))."\n";

sub sum {
	my $sum=0;
	for (@_ ) {
		$sum+=$_;
	}
	return $sum;
}

sub isPandigital {
	my $a=shift;
	my $b=shift;
	my $c=shift;
	my $str=$a.$b.$c;
	if (length($str) != 9 ) {
		return 0;
	}
	for ( 1..9 ) {
		if ( $str !~ /$_/ ) {
			return 0;
		}
	}
	return 1;
}