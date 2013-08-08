#!perl
use strict;
use warnings;
use Data::Dumper;
#use Math::GMP;
#use Math::Big::Factors;
#my $n = 1155;
use Benchmark;

my    $t0 = Benchmark->new;
    # ... your code here ...

for my $n (1..1e4) {
   # my @factors = Math::Big::Factors::factors_wheel($n,3);
    #print "Factors are ".join(',',@factors)."\n";
    my $numSolns = 0;
    #$numSolns = numDistinctSolutions ($n);
    if ( $numSolns == 10 ) {
        print "$n has $numSolns solns\n";
    }
}

my    $t1 = Benchmark->new;
my    $td = timediff($t1, $t0);
    print "the code took:",timestr($td),"\n";


sub numDistinctSolutions {
    my $n = shift;
    my $numSolutions = 0;
    for my $y( 1 .. $n ) {
        my $div = $n/$y;
        next unless ( isInteger($div) );
        my $a = (-$div-$y)/4;
        next unless ( isInteger($a) );
        my $x = $y - $a;
        next unless ( isNatural($x) );
        my $z = $y + $a;
        next unless ( isNatural($z) );
        #print "$div a $a x $x y $y z $z\n";
        $numSolutions++;
    }
    return $numSolutions;
}

sub isSquare {
    return ( sqrt($_[0]) == int(sqrt($_[0])) );
}
sub isInteger {
        return ($_[0] == int($_[0]));
}
sub isNatural {
        return ($_[0] > 0 && isInteger($_[0]));
}