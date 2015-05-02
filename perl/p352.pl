#!perl




%ev_cache;
my $a = ev_group(12,.02) + ev_group(13,.02);

my $b = ev_group(5,.02)*5;
my $max = 25;
for my $n( 1..$max) {
	my $result = ev_group($n,.02);
	my $eff = $n/$result;
	print "$n $result, \$n*\$result\ = $eff\n";
}

for my $n( 1..10) {
	my $result = ev_group($n,.02);
	my $eff = $n/$result;
	print "$n $result, \$n*\$result\ = $eff\n";
}

print "a $a b $b\n";

sub ev_group_shared {
	my $n = shift; # number of unknown infection status sheep in group 
	my $s = shift; # number of known infection status sheep in group
	my $p = shift; # probability of infection
	#my $key = "$n|$p";
	#if ( defined $ev_cache{$key} ) { return $ev_cache{$key} }
	
	my $q = 1 - $p;
	
	my $neg_chance = $q**$n;
	my $pos_chance_n_1 = (1-$neg_chance)*($q**($n-1));
	#print "\$pos_chance_n_1 = ".(1-$neg_chance)."*".($q**($n-1))."\n";
	
	my $positive_chance_n = (1-$neg_chance)*(1 - $q**($n-1));
	
	#$pos_chance_n_1 = 0;
	#$positive_chance_n = (1-$neg_chance);
	
	#print "$neg_chance $pos_chance_n_1 $positive_chance_n\n";
	#print "\$pos_chance_n_1 + \$positive_chance_n = $pos_chance_n_1 + $positive_chance_n = ".($pos_chance_n_1 + $positive_chance_n)."\n";
	#print "1 - $neg_chance = ".(1 - $neg_chance)."\n";
	my $ev = 
		1 + 
		($n-1)*$pos_chance_n_1 + 
		$n*$positive_chance_n;

	#print "ev $ev\n";
	# store
	#$ev_cache{$key} = $ev;
	
	return $ev;
}

sub ev_group {
	my $n = shift; # number of unknown infection status sheep in group 
	
	my $p = shift; # probability of infection
	#my $key = "$n|$p";
	#if ( defined $ev_cache{$key} ) { return $ev_cache{$key} }
	
	my $q = 1 - $p;
	
	my $neg_chance = $q**$n;
	my $pos_chance_n_1 = (1-$neg_chance)*($q**($n-1));
	#print "\$pos_chance_n_1 = ".(1-$neg_chance)."*".($q**($n-1))."\n";
	
	my $positive_chance_n = (1-$neg_chance)*(1 - $q**($n-1));
	
	#$pos_chance_n_1 = 0;
	#$positive_chance_n = (1-$neg_chance);
	
	#print "$neg_chance $pos_chance_n_1 $positive_chance_n\n";
	#print "\$pos_chance_n_1 + \$positive_chance_n = $pos_chance_n_1 + $positive_chance_n = ".($pos_chance_n_1 + $positive_chance_n)."\n";
	#print "1 - $neg_chance = ".(1 - $neg_chance)."\n";
	my $ev = 
		1 + 
		($n-1)*$pos_chance_n_1 + 
		$n*$positive_chance_n;

	#print "ev $ev\n";
	# store
	#$ev_cache{$key} = $ev;
	
	return $ev;
}
