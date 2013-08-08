#!perl
use strict;
use warnings;
# Problem 79
# 17 September 2004
# 
# 
# A common security method used for online banking is to ask the user for three random characters from a passcode. For example, if the passcode was 531278, they may asked for the 2nd, 3rd, and 5th characters; the expected reply would be: 317.
# 
# The text file, keylog.txt, contains fifty successful login attempts.
# 
# Given that the three characters are always asked for in order, analyse the file so as to determine the shortest possible secret passcode of unknown length.

createRules();

sub createRules {
	open(KEYLOG,"<",'keylog.txt');
	
	my %rules;
	my %digits;
	for (<KEYLOG>) {
		chomp;
		m/(.)(.)(.)/;
		$rules{"$1$2"} = 1;
		$rules{"$2$3"} = 1;		
		$digits{$1} = 1;
		$digits{$2} = 1;
		$digits{$3} = 1;				
#		print "($1,$2)\n";
#		print "($2,$3)\n";
	}
	
	print "Rules: ".join("\n",sort keys %rules) ."\n";
	print "Digits ". join(" ",sort keys %digits);
}

# NOTE:
# I solved this one by hand, along with the results from createRules
# to help me sort out the constraints.
# Here for posterity, are my guesses for the soln:
#10236789
#12036789
#31206789
#71236890
#71623890
#71362890
#73162890 DONE