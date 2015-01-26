#!perl
use Set::Object;
use strict;
use warnings;
use Data::Dumper;
use Benchmark ':hireswallclock';
use Algorithm::Permute;
use Math::Combinatorics;


# and this one is the speed demon:
  my @array = (0..3);
  Algorithm::Permute::permute { print "@array\n" } @array;


# infix expr
# must begin with op
# last element is num
# 2nd to last element is num
# always 7 elements
# 
# algo to make infix expr
# pick two from set {a,b,c,d}, and place at end
# pick op from list {+,-,*,/}, put at front

# all possible combos of operands for elements 2-5 of expression
# S = 
# num op num op
# num op op num
# op num num op
# op num op num
# op op num num 

# all infix expr for this problem follow format below
# op S num num 
# all combos of 3 operators 4c3
# all pick 2 subsets of set {a,b,c,d} 4p2 * 4c3
my %op = (
	'+'=> 10001,
	'-'=> 10002,
	'*'=> 10003,
	'/'=> 10004
);
my %opToString = (
	'10001' => '+',
	'10002' => '-',
	'10003' => '*',
	'10004' => '/'
);

my $opSet = Set::Object->new($op{'+'},$op{'-'},$op{'*'},$op{'/'});
my $numSet = Set::Object->new(0 .. 9);

evaluatePrefixExpression([$op{'+'},$op{'+'},$op{'+'},1,2,3,4]);
checkAllExpressions();
#my $td = timeit(10000000, evaluatePrefixExpression([$op{'+'},$op{'+'},$op{'+'},1,2,3,4]));
#print "the code took:",timestr($td),"\n";
sub randomPrefixExpression {
	my $s = Set::Object->new($numSet->members);
	my @nums;
}

sub checkAllExpressions {
	
	my $count = 0;
	my @opSet = ($op{'+'}..$op{'/'});
	my @tripleOpSet = (@opSet,@opSet,@opSet);
	
	
	my $combinat = Math::Combinatorics->new(count => 4,data => [0..9]);
	while(my @combo = $combinat->next_combination) {		
		print join(',',@combo)."\n";
		my $setPerms = new Algorithm::Permute(\@combo, 4);
		while (my @perm = $setPerms->next) {

			my $opCombos = Math::Combinatorics->new(count => 3,data => \@tripleOpSet);
			while (my @ops = $opCombos->next_combination) {
				#print opsListToString(\@ops)."\n";;
				$count++;
			}
			
		}
	}
	print "Combos $count\n";
}


sub opsListToString {
	my $ops = shift;
	my $str ='';
	for (@{$ops}) {
		$str .= $opToString{$_};
	}
	return $str;
}

sub isPrefixExpression {
	my $infix = shift;
}

sub evaluatePrefixExpression {
	my $infix = shift;
	# '+++1234' evals to 1+2+3+4 = 10
	my @exprStack;
	
	for ( @{$infix} ) {
		push (@exprStack,$_);
		print join(',',@exprStack). "\n";		
		if( @exprStack > 2 ) { 
			my $lastEl = $exprStack[-1];
			next if ( $lastEl >= $op{'+'} );
			my $secondLastEl = $exprStack[-2];
			next if ( $secondLastEl >= $op{'+'} );
			my $thirdLastEl = $exprStack[-3];
			next if ( $thirdLastEl < $op{'+'} );
			
			$#exprStack = $#exprStack - 3; # remove last 3 elements
			my $result; 
			if ( $thirdLastEl == $op{'+'} ) {
				$result = $lastEl + $secondLastEl;
			} elsif ( $thirdLastEl == $op{'-'} ) {
				$result = $lastEl - $secondLastEl;
			} elsif ( $thirdLastEl == $op{'*'} ) {
				$result = $lastEl * $secondLastEl;
			} elsif ( $thirdLastEl == $op{'/'} ) {
				$result = $lastEl / $secondLastEl;				
			}
			push(@exprStack,$result);
		}		
	}
	print join(',',@exprStack) . "\n";
	return @exprStack;
}