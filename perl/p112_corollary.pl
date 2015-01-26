#!perl
use warnings;
use strict;

print "Caw";
# frac is 1571129/1587000=0.989999369880277
# frac is 1572129/1588000=0.990005667506297

my $num = 1571129;
my $den = 1587000;

while ( 1) {
	$num++;
	$den++;
	print "".($num/$den) . "\n";;
	if ( $num/$den == .99) {
		die "$num/$den\n";
	}
}