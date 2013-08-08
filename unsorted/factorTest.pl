#!perl
use strict;
use warnings;
use Data::Dumper;
use Factor;
my $n = $ARGV[0];
print "Factoring $n\n";

my $fs = Factor::factor($n);

print Dumper($fs);
print "Done factoring\n";
if ( Factor::isCompleteFactorization($n,$fs) ) {
	print "$n is competely factorized\n";
}