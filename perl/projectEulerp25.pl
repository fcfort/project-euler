#!/usr/bin/perl.exe -w
use POSIX qw(ceil floor);
use Data::Dumper;
use strict;

my $fib1='1';
my $fib2='1';
for ( 3 .. 10000 ) {
	my $fibnew = add($fib1 ,$fib2);
	$fib1 = $fib2;
	$fib2 = $fibnew;

	print "$_ " .length($fibnew) . "\n";
	if ( length( $fibnew ) >= 1000 ) {
		print "$_ $fibnew " . length($fibnew) ."\n";
		die ;
	}
}


sub add {
	#print "arg1 $_[1]\n";
	my $a = shift;
	my $b = shift;
	#print "a $a b $b\n";
	$a = reverse $a;
	$b = reverse $b;
	
	my @a = split(//, $a);
	my @b = split(//, $b);
	##print "a: ".join(",",@a). " b: ".join(",",@b)."\n";
	my @sum;
	
	my $carry = 0;
	
	my $len = $#a > $#b ? $#a+1 : $#b+1;
	#print "len is $len\n";
	for (my $i=0; $i < $len; $i++ ) {
		my $op1 = 0;
		my $op2 = 0;
		if ( defined $a[$i] ) {
			$op1 += $a[$i];
		}
		if ( defined $b[$i] ) {
			$op2 += $b[$i];
		}		
		my $partialSum = $op1 + $op2 + $carry;
		#print "partialSum $op1 + $op2 + $carry =  $partialSum\n";
		my $digit = $partialSum % 10;
		$carry = ($partialSum - $digit)/10;	
		push(@sum,$digit);		
	}
	if($carry != 0 ) {
		push(@sum,$carry);
	}
	# print join(",",@sum);
	return join("",reverse @sum);
}