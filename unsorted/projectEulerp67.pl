#!/usr/bin/perl.exe -w
use Data::Dumper;
use Graph;
#use Graph::Easy;
#use Graph::Convert;
#use Graph::Easy::Node;

open(DATA, "projectEulerp67_data.txt");

my @file = <DATA>;
my @data;
for ( @file )  {
	#chomp;
	$_ =~ s/\n//g;
	# print '-'.$_.'-';
	#print join(',',split(/ /));
	my @temp = split(/ /);
	push(@data,\@temp);
}


my $s = Dumper(\@data);
$s =~ s/[\n\t ]//g;
print $s;
#print "\n$data[0][0] , $data[1][1].\n";

my $g = Graph->new(refvertexed => "1");


my $root;
my @leaves;

print "\n"; 
my @tempParents;
my $tempSharedChild;

for ($i=0; $i < $#data; $i++ ) {
	my $tempSharedChild = undef;
	for ($j=0; $j <= $#{$data[$i]}; $j++ ) {
		my $leftData = $data[$i+1][$j];
		my $rightData = $data[$i+1][$j+1];
		
		my $parent;
		my $left;
		my $right;
		
		# Define root
		if ($j==0 && $i==0 ) {
			my $parentData = $data[$i][$j];
			$parent = {'val' => $parentData};			
			$root = $parent;
		} else {
			$parent = shift(@tempParents);
		}
		
		if (defined $tempSharedChild ) {
			$left = $tempSharedChild;
		} else {
			$left = {'val' => $leftData};
			push(@tempParents, $left);
			if ( $i == $#data - 1 ) {
				push(@leaves,$left);
			}
		}
		$right = {'val' => $rightData};
		$tempSharedChild = $right;
		push(@tempParents,$right);
		# And all leaves
		if ( $i == $#data - 1 ) {			
			push(@leaves,$right);
		}
		
		#print "Row $i - Parent: $parent($parent->{val}), left: $left($left->{val}) right: $right($right->{val})\n";
		#print "Row $i - Parent: $parent->{val}, left: $left->{val} right: $right->{val} Stack: ".join(',',@tempParents)."\n";
		#print "Examining i,j $i,$j\n";
		$g->add_weighted_edge($parent,$left,100 - $left->{val});
		#print "Adding left $data[$i][$j] -> $data[$i+1][$j]\n";
		$g->add_weighted_edge($parent,$right,100 - $right->{val});
		#print "Adding right $data[$i][$j] -> $data[$i+1][$j+1]\n";
	}
}

my $max = 0;
for my $leaf ( @leaves ) {
	my @sp = $g->SP_Dijkstra($root, $leaf);
	my $last;
	my $sum = 0;
	for ( @sp ) {
		$sum += $_->{val};
	}
	print "To leaf $leaf->{val}, max path is $sum\n";
	if ( $sum > $max ) {
		$max = $sum;
	}
}
print "Max is $max\n";