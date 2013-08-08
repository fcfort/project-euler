#!perl
use strict;
use warnings;
use Boost::Graph;
use Data::Dumper;

open(MATRIX,"<",'matrix.txt');

my @matrix;
for (<MATRIX> ){
	chomp;
	my @nodes = split /,/;
	push(@matrix,\@nodes);
}

my $g = new Boost::Graph(directed=>1, net_name=>'Graph Name', net_id=>1000); 
for (my $y = 0; $y <= $#matrix; $y++) {	
	# last;
	#print "On row $y\n";
	for (my $x = 0; $x < 80; $x++ ) {		
		# right-pointing
		my $start = "$x,$y";
		if ( $x != 79 ) {
			my $right = ($x+1).",".$y;
			$g->add_edge(node1=>$start, node2=>$right, weight=>$matrix[$y][$x+1]);
		}
		# now to take care of down-pointing edges
		if ( $y != 79 ) {
			my $down = $x.",".($y+1);
			$g->add_edge(node1=>$start, node2=>$down, weight=>$matrix[$y+1][$x]);
		}		
	}
}
#print "num vert ". $g->nodecount() ." num edges " . $g->edgecount();
my $hashRef = $g->dijkstra_shortest_path('0,0','79,79');

print "Shortest path weight is ".($hashRef->{'weight'}+4445); # added 4445 to include value of first node