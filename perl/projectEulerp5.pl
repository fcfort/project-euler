#!/usr/bin/perl.exe -w


$max = 670442572800; # 670,442,572,800 i.e. 20!/10!
my @a = (19,18,17,16,15,14,13,12,11);
#for(@a){print "$_,";}
LOOP: for ($i=20;$i<$max;$i+=20) {
	#print "$i ";
	for my $div (@a) {
		if ( $i % $div != 0 ) {
			last;
		}
		if ($div < 13 ) {
			print "On $i, made it to $div\n";
		}
		if ( $div == 11 ) {
		
			print $i . " ";
			last LOOP;
		}
	} 
}

