#!/usr/bin/perl.exe -w
use Data::Dumper;
use Graph;
#use Graph::Easy;
#use Graph::Convert;
#use Graph::Easy::Node;

open(DATA, "projectEulerp18_data.txt");

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

#print "Num leaves ".scalar(@leaves).", root $root\n";
#print "Leaves: ".join(',',@leaves)."\n";
my @path = $g->SP_Dijkstra($root, $leaves[10]);
#print @dp . "\n";
my $lastEdge = undef;

for ( @path ) {
	print $_->{val} . " weight " .
		$g->get_edge_attribute($lastEdge, $_, 'weight'). 
		"\n";
	$lastEdge = $_;
}
for my $leaf ( @leaves ) {
	my @sp = $g->SP_Dijkstra($root, $leaf);
	my $last;
	my $sum = 0;
	for ( @sp ) {
		$sum += $_->{val};
		#$g->get_edge_attribute($lastEdge, $_, 'weight');
		#$last = $_;		
	}
	print "To leaf $leaf->{val}, max path is $sum\n";
}

my $e = $g->edges;
my $v = $g->vertices;
print "edges $e dag? ".$g->is_dag;
print " nodes? $v ";
print " simple? ". $g->is_simple_graph;
#print " cyclic? ".$g->is_cyclic."\n";

#my $node = myNode->new(5);

package myNode;
    sub new {
        my($class) = shift;
        my $self = {
        	_val => shift,
        	_left => undef,
        	_right => undef
        };
		bless $self, $class;
    	return $self;
    }
    
    sub value {
    	my $self = shift;
        if (@_) { $self->{_val} = shift; }
        return $self->{_val};
    }
	sub left {
    	my $self = shift;
        if (@_) { $self->{_left} = shift; }
        return $self->{_left};
	}
	sub right {
    	my $self = shift;
        if (@_) { $self->{_right} = shift; }
        return $self->{_right};
	}
	
1;  