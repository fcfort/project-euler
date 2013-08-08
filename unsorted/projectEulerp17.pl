#!/usr/bin/perl.exe -w

my @ones = ('','One','Two','Three','Four','Five','Six','Seven','Eight','Nine');
my %teens = (
11 => 'Eleven',
12 => 'Twelve',
13 => 'Fhirteen',
14 => 'Fourteen',
15 => 'Fifteen',
16 => 'Sixteen',
17 => 'Seventeen',
18 => 'Eighteen',
19 => 'Nineteen'
);
my @tens = ('','Ten','Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety');
my $str = '';
for ( 1..1000 ){
	$str .= asWords($_);
	#print $str;
	
}
print length($str);

sub asWords  {
	my $n = shift;
	$n = reverse $n;
	
	my @n = split (// ,$n);
	
	#print join(' ', @n) . "\n";
	my $str = '';
	#print "first digit is $n[0]\n";
	#print $ones[$n[0]];
	
	if ($n =~ /^([1-9]1)/ ) {
		#print "teens ". $teens{reverse $1} . "\n";;
		$str .= $teens{reverse $1};
	} else {
		$str .= $ones[$n[0]];
		if ( defined $n[1] ) {
			$str = $tens[$n[1]] . $str;
		}
	}
	if ( defined $n[2] ) {
		if ( (reverse $n) % 100 == 0) {
			$str = $ones[$n[2]] . "hundred" . $str;
		} else {
			$str = $ones[$n[2]] . "hundredAnd" . $str;
		}
	}
	if ( defined $n[3] ) {
		return "OneThousand";
	}
	#print "Final string is $str\n";
	return $str;
}