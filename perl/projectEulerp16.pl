#!/usr/bin/perl.exe -w



print "Sum of 3 and 4 is " . add(3,4) . "\n";
print "Sum of 16 and 16 is " . add(16,16) . "\n";
my $pow = 1;
for (1..1000 ){
	$pow = add($pow,$pow);
	#print "add of 2**$_ = $pow is " .sumOfDigits($pow) .  "\n";
	print "sumOfDigits of 2**$_ = $pow is " .sumOfDigits($pow) .  "\n";
}



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

sub add {
	my $a = shift;
	my $b = shift;
	# make a shortest
	if( length($a) > length($b) ) {
		my $temp = $a;
		$a = $b;
		$b = $temp;
	}
	
	
	$a = reverse $a;
	$b = reverse $b;
	
	my @a = split(//, $a);
	my @b = split(//, $b);
	
	my $sum = '';
	
	my $len = length($a);
	my $carry = 0;
	for ( my $i=0;$i<$len;$i++ ) {			
		$partialSum = shift(@a) + shift(@b) + $carry;
		#print "partialSum $a[$i] + $b[$i] is $partialSum\n";
		my $digit = $partialSum % 10;		
		$carry = ($partialSum - $digit)/10;
		$sum = $digit . $sum;
	}
	$carry =~ s/^0//;
	$sum = join('',reverse @b) . $carry . $sum;
	return $sum;
}