#!/usr/bin/perl.exe
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;
use warnings;
use PE;
use Acme::Comment;
use Math::BigInt;
/*
use Algorithm::Permute;
use Math::Combinatorics;
use Benchmark qw(:all) ;
use diagnostics;
*/

my @squareRoots;

for my $n ( 1..10000 ) {
	if ( ! PE::isSquare ( $n ) ) {
		push(@squareRoots,$n);
	}
}
/*
my $str;
for ( 255..255+200 ) {
	$str .= chr($_);
}
#print length($str);
*/
/*
my @strs =
('12121212121212121212',
'44444444444444444444',
'2424242424242424242424',
'111411141114111411',
'14141414141414141',
'66666666',
'3636363636363636363',
'16181618161816181');
for my $str ( @strs) {
	print "$str has period " . getStringPeriod($str)."\n";
	print "$str has rev period " . getStringPeriodRev($str)."\n";	
}
die;
*/
# print join (',',@squareRoots);

#getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(getNextA(4,4,1,23)))))))))));
#print "with new\n";
#getNextA(getNextA(getNextA(1,3,7,23)));
my $maxa0 = 0;
my $count = 0;
for my $n ( @squareRoots ) {
	my $a0 = ( floor(sqrt($n)) );
		if ( ($n % 100) == 0 ) {
			print "Checking $n\n";
		}
		my @coeffs = ($a0,$a0,1,$n);
		my $aStr = '';
		my $numStr = '';
		for my $i ( 1..500) {
			@coeffs = getNextA(@coeffs);
			$aStr .= encode($coeffs[0]);
			$numStr .= $coeffs[0] . " " ;
			if ( $coeffs[0] > $maxa0 ) {
				$maxa0 = $coeffs[0];
			}
			#print "$i: $coeffs[0]\n";
		}
		#my $period = getStringPeriod($aStr);
		my $period = getStringPeriodRev($aStr);
		# print "$n: $numStr period is ".$period." other calc is ".$period_rev."\n";

		if ( $period % 2 == 1 ) {
			#print "$n: $numStr period is ".$period."\n";
			$count++;
		}
		if ($period > 250) {
			print "$n: $numStr period is ".$period."\n";
			#die;
		}
}
print "odd period count is $count\n";
print "maxa0 is $maxa0\n";


sub getSqrtPeriod {


}

sub getStringPeriod { 
	my $str = shift;
	my $len = length($str);
	my $period = $len;
	for (my $i = floor($len/2); $i > 0 ;$i-- ) {
		my $numMatches = ($len - ($len % ($i*2)))/($i*2);
		#print "For $str of len $len for match len $i, numMatches is $numMatches\n";		
		if ( $str =~ /(?:(.{$i})\1){$numMatches}/ ) {
			$period = $i;
		}
	}
	return $period;
}

sub getStringPeriodRev {
	my $str = shift;
	my $len = length($str);
	my $period = $len;
	for (my $i = 1; $i <=  floor($len/2);$i++ ) {
		my $numMatches = ($len - ($len % ($i*2)))/($i*2);
		#print "Rev For $str of len $len for match len $i, numMatches is $numMatches\n";		
		if ( $str =~ /(?:(.{$i})\1){$numMatches}/ ) {
			# $period = $i;
			return $i;
		}
	}
	return $period;
}

sub getNextA {
	my $a = shift;
	my $b = shift;
	my $c = shift;
	my $sqrt = shift;
	
	my $c_new = ($sqrt - $b**2)/$c;
	#print "a' before floor (sqrt($sqrt) + $b)/$c_new) = ".((sqrt($sqrt) + $b)/$c_new)."\n";
	my $a_new = floor((sqrt($sqrt) + $b)/$c_new);
	my $b_new = $a_new*$c_new - $b;	
	#print "New $a_new $b_new $c_new $sqrt\n";
	return ($a_new,$b_new,$c_new,$sqrt);
}

sub encode {
	my $num = shift;
	return chr(500 + $num);
}

sub decode {

}