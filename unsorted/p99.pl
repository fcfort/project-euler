#!perl
use strict;
use warnings;
#Problem 99
#01 July 2005
#
#
#Comparing two numbers written in index form like 211 and 37 is not difficult, as any calculator would confirm that 211 = 2048  37 = 2187.
#
#However, confirming that 632382518061  519432525806 would be much more difficult, as both numbers contain over three million digits.
#
#Using base_exp.txt (right click and 'Save Link/Target As...'), a 22K text file containing one thousand lines with a base/exponent pair on each line, determine which line number has the greatest numerical value.
#
#NOTE: The first two lines in the file represent the numbers in the example given above.

# ED. i will go off the assumption that if a^^b > x^^y, then b log a > y log x


open(EXPS,"<",'base_exp.txt');
my $maxNum = 0;
my $maxLineNumber = 0;
my $lineNum = 0;

for ( <EXPS> ) {
	$lineNum++;	
	chomp;
	my @pair = split /,/;
	my $result = $pair[1] * log ( $pair[0] );
	if ($result > $maxNum) {
		$maxLineNumber = $lineNum;
		$maxNum = $result;
	}

}

print "max line is $maxLineNumber\n";