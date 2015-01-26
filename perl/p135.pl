#!perl
use strict;
use warnings;
use Data::Dumper;

#my $n = 1155;
use Benchmark ':hireswallclock';

my    $t0 = Benchmark->new;
my @divs = Divisors(234654562);
my    $t2 = Benchmark->new;
my $td = timediff($t2, $t0);
    print "the code took:",timestr($td),"\n";
    
print join(',',@divs)."\n";

    # ... your code here ...
my @nums;
for my $n (500000..600000) {
    #print "Factors are ".join(',',@factors)."\n";
    my $numSolns = 0;
    $numSolns = numDistinctSolutions ($n);
    if ( $numSolns == 10 ) {
        print "$n has $numSolns solns\n";
        push(@nums,$n);
    }
}
print join(',',@nums)."\n";

my    $t1 = Benchmark->new;
   $td = timediff($t1, $t0);
    print "the code took:",timestr($td),"\n";


sub numDistinctSolutions {
    my $n = shift;
    my $numSolutions = 0;
    print $n . "\n" ;
    my @divsn = Divisors($n);
    for my $y(@divsn ) {
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

# attach to mathematica
sub Divisors {
	my $n = shift;
	my $result = `./math -noprompt -noinit -run 'Print[Divisors[$n]];Exit[];'`;
	chomp $result;
	$result =~ s/[{} ]//g;
	#print $result;
	return split (m/,/,$result);
}