#!perl
use strict;
use warnings;
use Data::Dumper;
use Math::BigRat   lib => 'GMP';;
#use Math::BigInt 
use Math::BigFloat  lib => 'GMP';
use Benchmark;
# NOTE TO SELF, used mathematica to find the answer: 10/Sep/2009 16:18
#Nest[Floor[2^(30.403243784 - #^2)]*(10^-9) &, -1, 10000 - 1] + Nest[Floor[2^(30.403243784 - #^2)]*(10^-9) &, -1, 10000]



# Problem 197
# 06 June 2008
# 
# 
# Given is the function f(x) = [2**(30.403243784-x**2)] x 10**-9 ( [] is the floor-function),
# the sequence un is defined by u0 = -1 and un+1 = f(un).
# 
# Find un + un+1 for n = 1012.
# Give your answer with 9 digits after the decimal point.

#print "f is " . f(-1);
#for  ( 0 .. 10 ){
#	my $u = u($_);
#	my $u_next = u($_+1);
#	print "u of $_ is " .$u."\n";
#	print "u of $_+1 is " .$u_next."\n";
#	print "Sum is " .($u+$u_next)."\n";	
#}
$G::weird_power = Math::BigFloat->new('30.403243784');
# u(100);

#my $t0 = Benchmark->new;
    # ... your code here ...

my $k = Math::BigRat->new('1029461839/1000000000')+Math::BigRat->new('340587939/500000000');
print "answer is $k\n";
die;



my %umap;
for ( 0..20 ) {
	print "u of $_ is " .u($_)."\n";
}
#my $t1 = Benchmark->new;
#my $td = timediff($t1, $t0);
#    print "the code took:",timestr($td),"\n";




sub f {
	my $x = shift;	
	$x = Math::BigFloat->new($x);
	print "x is $x\n";
	$x->bpow(2);
	print "x**2 is $x\n";
	$x = $G::weird_power - $x;
	print "exponent is $x\n";
	my $f = Math::BigFloat->new(2);
	$f->bpow($x);
	print "before floor for 2**$x: $f\n";
	$f->bfloor();
	print "after floor for floor(2**$x): $f\n";
	$f->bmul(Math::BigFloat->new(10)->bpow(-9));
	return $f;
}

sub u { 
	my $x = shift;
	print "Calculating u($x)\n";
	if ( $x == 0 ) {
		return -1;
	}
	if ( defined $umap{$x} ) {
		print "getting value $x from umap\n";
		return $umap{$x};
	}
	my $u = f ( u ($x - 1) ); 
	$umap{$x} = $u;
	print "u of $x is $u\n";
	return $u;
}

