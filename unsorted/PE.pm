package PE;
use 5.006;
use strict;
use warnings;
use POSIX qw(ceil floor);
use Benchmark;
#require Exporter;
#our @ISA = qw(Exporter);
#our %EXPORT_TAGS = ( 'all' => [ qw() ] );
#our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
#our @EXPORT = qw( );

@PE::primes = @{readPrimes()};
#print "Done loading all primes up to $PE::primes[$#PE::primes]\n";
#
#timethese(5,{ 'readPrimes' => \&readPrimes,
#                'readPrimesChomp' => \&readPrimesChomp
#              });
#die;
#########
# Prime numbers
#########

sub isPrime {
	my $n = shift;
	#throw-away non-integers
	if ( floor($n) != $n || $n < 0) {
		return 0;
	}
	if ( $n == 2 ){return 1;}
	if ( $n > $PE::primes[$#PE::primes] ) {
		warn "Prime too big ($n)";
		return 0;
	} else {
		#Binary search
		my $l = 0;
		my $r = $#PE::primes + 1;
		my $p = floor(($r - $l)/2);
		while( $p != 0 ) {
			$p += $l;
			if ( $PE::primes[$p] < $n ) {
				#print "Lower bound set to $p\n";
				$l = $p;
			} elsif ( $PE::primes[$p] > $n ) {
				#print "Upper bound set to $p\n";
				$r = $p;
			} else {
				return 1;
			}
			$p = floor(($r - $l)/2);
		}
	}
	return 0;
}

sub distinctPrimeFactors { 
	my $n = shift;
	return scalar(keys %{primeFactorization($n)});
}

sub primeFactorization {
	my $num = shift;
	if ( isPrime ( $num ) ) { return {} };
	my $origNum = $num;
	my %primeFactors;
	# print "$num: ";
	my $s = sqrt($num);
	# print "Finding primes of $num\n";
	
	for ( my $i=0; $i <= $#PE::primes;  $i++  ) {
		my $pi = $PE::primes[$i];
		# print "Checked new prime $pi\n";		
		while($num % $pi == 0) {
			$num /= $pi;
			if ( $origNum != $pi ) {
				# print "Adding prime $pi\n";
				$primeFactors{$pi}++;
			}
		}		
		if ( $num == 1 || $pi > $origNum/2) {
			# print "Stopping, all primes found ($num==1) or $pi > ".$origNum/2."\n";
			return \%primeFactors;
		}
	}	
	die "wrong place or $num too big\n";
}

sub readPrimes {
	# loads primes less than 1e6 plus one more
	my @primeFiles = ("primes0_1mil.txt" );#,"primes1_2mil.txt","primes2_3mil.txt");
	my @data;
	for my $file ( @primeFiles ) {
		open(DATA, $file);
		#my @file = <DATA>;
		for ( <DATA> )  {
			chomp;
			push(@data,$_);
		}
	}
	return \@data;
}

sub readPrimesChomp {
	# loads primes less than 1e6 plus one more
	my $file = "primes15e6.txt";
	#my $file = "tempPrimes.txt";
	open(DATA, $file);
	#my @file = <DATA>;
	chomp(my @data = <DATA>);
	return \@data;
}

#########
# Figurate numbers
#########

sub isTriangular {
	my $n = shift;
	return isNatural((sqrt(8*$n + 1) - 1)/2);
}

sub isPentagonal {
	my $n = shift;
	return isNatural((sqrt(24*$n + 1) + 1)/6);
}

sub isHexagonal {
	my $n = shift;
	return isNatural((sqrt(8*$n + 1) + 1)/4);
}

#######
# Other numerical properties
#######

sub isNatural {
	my $n = shift;
	return ($n > 0 && isInteger($n));
}

sub isInteger {
	return ($_[0] == floor($_[0]));
}

sub isPandigital {
	#defaults to pandigital-9 (i.e. 1,2,3,4,5,6,7,8,9)
	my $str = shift;
	my $numDigits = shift;
	if (! defined $numDigits ) {
		$numDigits = 9;
	}
	if (length($str) != $numDigits ) {
		return 0;
	}
	for ( 1 .. $numDigits ) {
		if ( $str !~ /$_/ ) {
			return 0;
		}
	}
	return 1;
}

sub isDivisibleBy {
	my $n =shift;
	my $by = shift;
	if ( $n % $by == 0 ) {
		return 1;
	} else {
		return 0;
	}
}

sub digitalSum {
	my $n = shift;
	my $sum = 0;
	while ( length($n) ) {
		$sum += chop($n);
	}
	return $sum;
}

#########
# Strings
#########

sub wordValue {
	my $word = shift;
	my @letters = split(//,$word);
	my $val = 0;
	for my $letter (@letters) {
		$val +=ord($letter) - 64;
	}
	return $val;
}

sub lchop {
	#chops from left side;
	my $ref = \$_[0];
	my $r = reverse(${$ref});
	my $letter = chop($r);
	${$ref} = reverse $r;
	return $letter;
}

#########
# Misc
#########

sub sum {
	my $sum=0;
	for (@_ ) {
		$sum+=$_;
	}
	return $sum;
}

return 1;
