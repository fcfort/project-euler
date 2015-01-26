#!/usr/bin/perl.exe -w
use Data::Dumper;
use strict;

#print add(5,15);
#print mult('50051510','51090942171709440000');
my $result = factorial(100);
print "100! is $result\n";
print "sum of digits($result) ". sumOfDigits($result);
sub sumOfDigits {
	my $s = shift;
	my @a = split(//, $s);
	#print @a;
	my $sum = 0;
	for ( @a ){
		$sum+=$_;
	}
	return $sum;
}

sub factorial {
	my $n = shift;
	my $result = 2;
	for (my $i=3; $i <= $n; $i++ ) {
		my $newResult = mult($i.'',$result.'');
		#print "mult: $i*$result=$newResult\n";		
		$result = $newResult;
	}
	return $result;
}


sub mult {
	my $a = shift;
	my $b = shift;
	my $sum = 0;
	for ( 1 .. $a ) {
		my $newSum = add($b.'',$sum.'');
		#print "sum $_: $b+$sum=$newSum\n";		
		$sum = $newSum;
	}
	return $sum;
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

sub add_old {
	my $a = shift;
	my $b = shift;
	# make a shortest
	#print "adding $a+$b\n";
	if( length($a) > length($b) ) {
		my $temp = $a;
		$a = $b;
		$b = $temp;
	}
	#print "adding $a+$b\n";
	$a = reverse $a;
	$b = reverse $b;
	
	my @a = split(//, $a);
	my @b = split(//, $b);
	#print "a: ".join(",",@a). " b: ".join(",",@b)."\n";
	my $sum = '';
	
	my $len = length($a);
	my $carry = 0;
	for ( my $i=0;$i<$len;$i++ ) {			
		my $partialSum = shift(@a) + shift(@b) + $carry;
		#print "partialSum $a[$i] + $b[$i] is $partialSum\n";
		my $digit = $partialSum % 10;		
		$carry = ($partialSum - $digit)/10;
		#print "digit $digit carry $carry\n";
		$sum = $digit . $sum;
		print "sum so far is $sum\n";
	}
	$carry =~ s/^0//;
	if ( $carry eq '' ) {$carry = 0;}
	
	my $leftover = join('',reverse @b) . '';
	if ($leftover eq '' ) {$leftover = 0;}
	if ( $sum == 0 ) {$sum = '';}
	print "sum  a is $sum\n";
	$sum = ($leftover + $carry) . $sum . '';
	$sum =~ s/^0//;
	print "sum is $sum\n";	
	return $sum;
}