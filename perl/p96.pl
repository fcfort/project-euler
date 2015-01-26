#!perl
use strict;
use warnings;
use Data::Dumper;
use Set::Object;

package Sudoku;
use Moose;
	has 'array' => ( is => 'rw' );

	sub toString {
		my $self = shift;

		my $s = $self->array;
		my @printArray;

		# initialize to all spaces
		for (my $i = 0; $i <27;$i++){
			for (my $j = 0; $j<27;$j++){
				$printArray[$i][$j] = ' ';
			}
		}

		my @offsetArrayX = (0,1,2,0,1,2,0,1,2);
		my @offsetArrayY = (0,0,0,1,1,1,2,2,2);

		for (my $i = 0; $i < 9;$i++){
			for (my $j = 0; $j<9;$j++){
				#print scalar(@{$s->[$i][$j]});
				if (scalar(@{$s->[$i][$j]}) == 1) {
					#print join(',',@{$s->[$i][$j]})."\n";
					$printArray[1+$i*3][1+$j*3] = $s->[$i][$j][0];
				} else {
					my $offsetIndex = 0;
					for my $num (@{$s->[$i][$j]}) {
						$printArray
							[$offsetArrayY[$offsetIndex]+$i*3]
							[$offsetArrayX[$offsetIndex]+$j*3]
							= $num;

						$offsetIndex++;
					}

				}
			}
		}

		my $outputString ='';
		my $topWidth = 41;
		$outputString .= ("-"x$topWidth)."\n";
		$outputString .= ("-"x$topWidth)."\n";
		my $rowIndex = 1;
		for my $row (@printArray) {
			my $rowString;
			my $colIndex = 1;
			for ( @{$row} ) {
				if ( ($colIndex -1 ) % 3 == 0) {
					$rowString .= '|';
				}
				if ( ($colIndex-1)% 9 == 0) {
					$rowString .= '|';
				}
				$rowString .= $_;
				$colIndex++;
			}
			$rowString .= '||';
			#join('',@{$row}[0..8]) . "||".
			#join('',@{$row}[9..17]) . "||" .
			#join('',@{$row}[18..26]);
			# my $rowString = join('',@{$row});
			$outputString .= "$rowString\n";
			if ( $rowIndex % 3  == 0 ){
				$outputString .=  ("-"x$topWidth)."\n";
			}
			if ( $rowIndex % 9  == 0 ){
				$outputString .=  ("-"x$topWidth)."\n";
			}
			$rowIndex++;
		}
		return $outputString;
	}

	sub getBox {
		my $self = shift;
		my $boxI = shift;
		my $boxJ = shift;

		my @oneBox;

		for (my $i = 0; $i < 3;$i++){
			for (my $j = 0; $j<3;$j++){
				$oneBox[$i][$j] = $self->array->[$boxI*3+$i][$boxJ*3+$j];
			}
		}
		return \@oneBox;
	}

	sub boxIterator {
	    my $self = shift;

		my @xs = (0,1,2,0,1,2,0,1,2);
		my @ys = (0,0,0,1,1,1,2,2,2);

		my $i = 0;
		my $j = 0;

	    return sub {
	    	if( $i < 9 ) {
	    		return $self->getBox($xs[$i++],$ys[$j++]);
	    	} else {
	    		return undef;
	    	}
		};
	}

	sub getCol {
		my $self = shift;
		my $col = shift;
		# cols are a single array with 9 elements
		my @colStruct;
		for (my $row = 0; $row < 9; $row++) {
			push(@colStruct,$self->array->[$row][$col]);
		}
		return \@colStruct;
	}

	sub colIterator {
	 	my $self = shift;

		my $i = 0;

	    return sub {
	    	if ( $i < 9 ) {
		    	return $self->getCol($i++);
	    	} else {
	    		return undef;
	    	}
		};
	}

	sub getRow {
		my $self = shift;
		my $rowIndex = shift;
		my $r = $rowIndex;
		# rows are a single array with 9 elements
		my @rowStruct;
		for (my $col = 0; $col < 9; $col++) {
			push(@rowStruct,$self->array->[$r][$col]);
		}
		return \@rowStruct;
	}

	sub rowIterator {
	 	my $self = shift;

		my $i = 0;

	    return sub {
	    	if ( $i < 9 ) {
		    	return $self->getRow($i++);
	    	} else {
	    		return undef;
	    	}
		};
	}

    sub elementIterator {
        my $self = shift;
        my $nextRow = $self->rowIterator();
        
        my $rowi = 0;
        my $coli = 0;
        
        
        return sub {
          my $row = $self->getRow($rowi);
          my $nextEl = $row->[$coli];
          $coli++;
          if ( $coli > 8 ) {
            $coli = 0;
            $rowi++;
          }
          if ( $rowi > 8) {
            return undef;
          }
          return $nextEl;          
        }        
    }
        

	sub eliminateInBoxAnswers {
		my $su = shift;
		my $elementsEliminated = 0;

		my $nextBox = $su->boxIterator();
		while ( my $box = $nextBox->() ) {
			my $set = Set::Object->new(main::getSolvedFromBox($box));
			#print "Looking at another box\n";

			my $nextBoxEl = main::boxElementIterator($box);
			#main::printBox($box);
			while ( my $boxEl = $nextBoxEl->() ) {
				if ( $boxEl->size > 1 ) {
					my $intersection = $boxEl * $set;
					$elementsEliminated += $intersection->size;
					$boxEl->remove($set->members);
				}
			}
		}
		return $elementsEliminated;
	}

	sub eliminateInRowAnswers {
		my $su = shift;
		my $elementsEliminated = 0;

		my $nextRow = $su->rowIterator();
		while ( my $row = $nextRow->()) {
			#eliminate solved members of that box from the other elements
			my $set = Set::Object->new(main::getSolvedFromRow($row));
			#print "set is $set\n";
			for my $rowEl (@{$row}) {
				next unless ( $rowEl->size > 1 );

				my $intersection = $rowEl * $set;
				$elementsEliminated += $intersection->size;
				$rowEl->remove($set->members);
				#print "after $i,$j $box->[$i][$j]\n";
				# if solved, print
				if ( $rowEl->size == 1 ) {
					#print "On row $rowI, col $i, $row solved\n";
				}
			}
		}
		return $elementsEliminated;
	}

	sub eliminateInColAnswers {
		my $su = shift;
		my $elementsEliminated = 0;

		my $nextCol = $su->colIterator();
		while ( my $col = $nextCol->()) {
			#eliminate solved members of that box from the other elements
			my $set = Set::Object->new(main::getSolvedFromCol($col));
			#print "set is $set\n";
			for my $colEl (@{$col}) {
				next unless ( $colEl->size > 1 );

				my $intersection = $colEl * $set;
				$elementsEliminated += $intersection->size;
				$colEl->remove($set->members);
				#print "after $i,$j $box->[$i][$j]\n";
				# if solved, print
				if ( $colEl->size == 1 ) {
					#print "On row $rowI, col $i, $row solved\n";
				}
			}
		}
		return $elementsEliminated;
	}

	sub eliminateSolitaryBoxNumbers {
		my $su = shift;
		my $elementsEliminated = 0;

		my $nextBox = $su->boxIterator();
		while ( my $box = $nextBox->() ) {
			#my $box = $su->getBox(0,2);
			#print "On box so and so \n";
			#main::printBox($box);
			my @listOfSets;
			my $mergedSet = Set::Object->new();

			my $nextBoxEl = main::boxElementIterator($box);
			while ( my $boxEl = $nextBoxEl->() ) {
				if ( $boxEl->size > 1 ) {
					push(@listOfSets,$boxEl);
					#print "adding $boxEl to list of sets\n";
					$mergedSet->insert($boxEl->members);
				}
			}

			# now remove elements that have already been solved
			my @solvedSet = main::getSolvedFromBox($box);
			$mergedSet->remove(@solvedSet);

			#print "merged set is $mergedSet\n";
			my %elCount;
			# count number of occurences for each number
			NUMBER: for my $el ($mergedSet->members) {
				#print "Examining $el\n";
				for my $set ( @listOfSets ) {
					if ( $set->contains($el) ) {
						$elCount{$el}++;
						next NUMBER if ( $elCount{$el} > 2 );
					}
				}
			}
			#print main::Dumper(\%elCount);

			# if any have just one occurence, the set with that element is now
			# solved
			SOLVEDNUMBER: for my $num (keys %elCount ) {
				if (  $elCount{$num} == 1 ) {
					#print "$num has one occurence\n";
					for my $set ( @listOfSets ) {
						if ( $set->contains($num) ) {
							$elementsEliminated += $set->size - 1;
							#print "before $set\n";
							my $singleElementSet = Set::Object->new( $num );
							#$set = $set * $singleElementSet;
							$set->clear();
							$set->insert($num);
							#print "after $set $singleElementSet\n";
							#last SOLVEDNUMBER;
						}
					}
				}
			}
			# done with one box
		}
		#print "$elementsEliminated removed\n";
		return $elementsEliminated;
	}

	sub eliminateInlineFromPairedNumbers {
		my $s = shift;
		my $elementsEliminated = 0;
		for my $row ( 0..2 ) {
			for my $col ( 0.. 2 ) {
				my $box = $s->getBox($row,$col);
				my @solvedList = main::getSolvedFromBox($box);
				my $solvedSet = Set::Object->new(@solvedList);

				my %numberPositions;

				# record positions of unsolved numbers
				for my $boxRow ( 0..2 ) {
					for my $boxCol ( 0.. 2 ) {
						my $boxEl = $box->[$boxRow][$boxCol];
						next unless ( $boxEl->size > 1 );
						#print $boxEl . "\n";
						for my $num ( $boxEl->members ) {
							push(@{$numberPositions{$num}{'x'}},$col*3 + $boxCol);
							push(@{$numberPositions{$num}{'y'}},$row*3 + $boxRow);
						}
					}
				}

				for my $num ( keys %numberPositions ) {
					next if ( $solvedSet->contains(  $num ));
					if ( allSame( $numberPositions{$num}{'x'})
						||
						 allSame( $numberPositions{$num}{'y'})
					) {
						if ( allSame( $numberPositions{$num}{'x'} )) {
						# for elements in the same col
							my $xPos = $numberPositions{$num}{'x'}->[0];
							#print "Found elimination for $num for col $xPos in box $row,$col\n";
							my $colElementsToSkip = Set::Object->new ( $row*3 .. $row*3+2 );
							my $colArray = $s->getCol($xPos);

							my $n = 0;
							for my $colEl ( @{$colArray} ) {
								unless ($colElementsToSkip->contains($n) ) {
									if ( $colEl->contains($num) ) {
										#print "Eliminating option $num at row $n of col $xPos\n";
										$elementsEliminated++;
										$colEl->remove($num);
									}
								}
								$n++;
							}
						} elsif ( allSame( $numberPositions{$num}{'y'} )) {
						# for elements in the same row
							my $yPos = $numberPositions{$num}{'y'}->[0];
							#print "Found elimination for $num for row $yPos in box $row,$col\n";
							my $rowElementsToSkip = Set::Object->new ( $col*3 .. $col*3+2 );
							my $rowArray = $s->getRow($yPos);

							my $n = 0;
							for my $rowEl ( @{$rowArray} ) {
								unless ($rowElementsToSkip->contains($n) ) {
									if ( $rowEl->contains($num) ) {
										#print "Eliminating option $num at col $n of row $yPos\n";
										$elementsEliminated++;
										$rowEl->remove($num);
									}
								}
								$n++;
							}
						}
					}
				}
			}
		}
		return $elementsEliminated;

		# returns true if all elements of an array are equal
		sub allSame {
			my $array = shift;
			for ( @{$array} ) {
				return 0 if ( $_ != $array->[0] );
			}
			return 1;
		}
	}

	sub isSolved {
		my $su = shift;
		
		my $allNumberSet = Set::Object->new ( 1..9 );
		#check by ROW
		my $nextRow = $su->rowIterator();
		while ( my $row = $nextRow->()) {
			my $rowSet = Set::Object->new;
			for my $boxEl ( @{$row} ) {
				# firstly all boxes must contain at most one element
				if  ( $boxEl->size != 1 ) {
					return 0;
				} else {
					$rowSet->insert( $boxEl->members );
				}
			}
			# check if each row contains 1..9
			if ( $rowSet != $allNumberSet ) {
				return 0;
			}
			# check if each column contains 1..9
		}
		
		#check by COLUMN
		my $nextCol = $su->colIterator();
		while ( my $col = $nextCol->()) {
			my $colSet = Set::Object->new;
			for my $boxEl ( @{$col} ) {
				# firstly all boxes must contain at most one element
				if  ( $boxEl->size != 1 ) {
					return 0;
				} else {
					$colSet->insert( $boxEl->members );
				}
			}
			# check if each column contains 1..9
			if ( $colSet != $allNumberSet ) {
				return 0;
			}			
		}	
		# check by BOX
		my $nextBox = $su->boxIterator();
		while ( my $box = $nextBox->() ) {
			my $boxSet = Set::Object->new;
			my $nextBoxEl = main::boxElementIterator($box);
			while ( my $boxEl = $nextBoxEl->() ) {
				# firstly all boxes must contain at most one element
				if  ( $boxEl->size != 1 ) {
					return 0;
				} else {
					$boxSet->insert( $boxEl->members );
				}
			}
			# check if each column contains 1..9
			if ( $boxSet != $allNumberSet ) {
				return 0;
			}			
		}				

		return 1;
	}

	sub clone {
		my $s_orig = shift;
		my $s_array_copy;
		for my $i ( 0..8 ) {
			for my $j ( 0..8 ) {
				#print "$i $j".$s_orig->array->[$i][$j]."\n";
				$s_array_copy->[$i][$j] = 
					Set::Object->new($s_orig->array->[$i][$j]->members);
			}
		}
		return Sudoku->new('array'=>$s_array_copy);
	}

	sub guessAndCheck {
		print "Sudoku->guessAndCheck() called\n";
		my $s = shift;

		my $nextUnsolved = $s->getUnsolvedStatesIterator();
		while (my $unsolvedEl = $nextUnsolved->() ) {
			my $s_copy = $s->clone;
			print "Making change at (".$unsolvedEl->{'row'},',',$unsolvedEl->{'col'},'), from',$unsolvedEl->{'from'},"to ",$unsolvedEl->{'to'},"\n";
			$s->makeChange(
			    $unsolvedEl->{'row'},$unsolvedEl->{'col'},
			    $unsolvedEl->{'to'});            
			print "Attempting to solve\n";
			$s->solve();
			print "Done trying to solve\n";

			if ( $s->isSolved() ) {
				print "Sudoku solved\n";
				#print $s->toString;
				#print "Printing copy for good measure\n";
				#print $s_copy->toString;
				return 1;
			} elsif ( ! $s->isConsistent() ) {
				print "Sudoku inconsistent, restoring...\n";
				print "Undoing change at (".$unsolvedEl->{'row'},',',$unsolvedEl->{'col'},'), restoring from',$unsolvedEl->{'to'},"to ",$unsolvedEl->{'from'},"\n";
				$s->copy($s_copy);
				next;
			} else {
				# not solved and consistent, then recurse
				print "Sudoku still not solved, recursing...\n";
				print $s->toString;
				
				$s->guessAndCheck();
			}
		}

		sub getUnsolvedStatesIterator {
			my $s  = shift;
			my @unsolvedElements;
			my $iterIndex = 0;
			# collect unsolved elements and their position
			for my $rowIndex ( 0..8 ) {
				my $row = $s->getRow( $rowIndex );
				for my $colIndex (0 .. 8) {
					my $rowEl = $row->[$colIndex];
					if ( $rowEl->size != 1 ) {
						for my $num ( $rowEl->members ) {
							push(@unsolvedElements,
								{
									'row' => $rowIndex,
									'col' => $colIndex,
									'from'  => Set::Object->new($rowEl->members),
									'to'  => Set::Object->new($num)
								}
							);
						}
					}
				}
			}
			# iterator return function
			return sub {
				if ( $iterIndex <= $#unsolvedElements ) {
					return $unsolvedElements[$iterIndex++];
				} else {
					return undef;
				}
			}
		}
	}

	sub makeChange {
		my $s = shift;
		my ($rowIndex,$colIndex,$newSet) = @_;

		my $row = $s->getRow($rowIndex);
		my $set = $row->[$colIndex];
		$set->clear();
		$set->insert($newSet->members);	    
		#$s->array->[$rowIndex][$colIndex]->clear;
		#$s->array->[$rowIndex][$colIndex]->insert($newSet->members);
	}

	sub solve {
		my $s = shift;
		my $iters = 0;
		my $elsGone = 0;
		do {
			$iters++;
			$elsGone = $s->eliminateInBoxAnswers();
			$elsGone += $s->eliminateInRowAnswers();
			$elsGone += $s->eliminateInColAnswers();
			$elsGone += $s->eliminateSolitaryBoxNumbers();
			$elsGone += $s->eliminateInlineFromPairedNumbers();

		} while ( $elsGone > 0);

		# then do another three iterations for good measure
		for ( 0 .. 2 ) {
			$elsGone = $s->eliminateInBoxAnswers();
			$elsGone += $s->eliminateInRowAnswers();
			$elsGone += $s->eliminateInColAnswers();
			$elsGone += $s->eliminateSolitaryBoxNumbers();
			$elsGone += $s->eliminateInlineFromPairedNumbers();
		}
		#return $s->isSolved();
	}

	sub isConsistent {
	    my $s = shift;
	    my $elIterator = $s->elementIterator;
	    # check for empty elements
	    while ( my $nextEl = $elIterator->() ) {
	        if ( $nextEl->size == 0 ) {
	            return 0;
	        }
	    }
	    # check for duplicated solved elements within a box
	    my $nextBox = $s->boxIterator;
	    while ( my $box = $nextBox->() ) {
			my $solvedSet = Set::Object->new;
			my $nextBoxEl = main::boxElementIterator($box);
			while ( my $boxEl = $nextBoxEl->() ) {
				if ( $boxEl->size == 1 ) {
					if ( $solvedSet->contains($boxEl->members) ) {
						return 0;
					} else {
						$solvedSet->insert($boxEl->members);
					}
				}
			}
	    }
	    # check for duplicated solved elements within a row
	    my $nextRow = $s->rowIterator;
	    while ( my $row = $nextRow->() ) {
			my $solvedSet = Set::Object->new;
			for my $el ( @{$row} ) {
				if ( $el->size == 1 ) {
					if ( $solvedSet->contains($el->members) ) {
						return 0;
					} else {
						$solvedSet->insert($el->members);
					}
				}
			}
		}
	    # check for duplicated solved elements within a col
	    my $nextCol = $s->colIterator;
	    while ( my $col = $nextCol->() ) {
			my $solvedSet = Set::Object->new;
			for my $el ( @{$col} ) {
				if ( $el->size == 1 ) {
					if ( $solvedSet->contains($el->members) ) {
						return 0;
					} else {
						$solvedSet->insert($el->members);
					}
				}
			}
		}  	    
	    return 1;
	}
	
	sub copy {
		my ($su,$s_copy) = @_;

		for my $i ( 0..8 ) {
			for my $j ( 0..8 ) {
				my $el = $su->array->[$i][$j];
				$el->clear;
				$el->insert($s_copy->array->[$i][$j]->members);
			}
		}
	}
	
	sub getTopLeftSum {
		my $s = shift;
		
		my $row = $s->getRow(0);
		
		my @elements;
		for ( 0 .. 2 ) {
			die if ($row->[$_]->size != 1 );
			push(@elements,$row->[$_]->members);
		}
		my $digits = 0;
		for ( @elements) {
			$digits .= $_;
		}
		my $total = int($digits);
		print "Combining ".scalar(@elements)." together: $elements[0] . $elements[1] . $elements[2] = $total\n";
		return $total;
	}

__PACKAGE__->meta->make_immutable;
no Moose;
package main;

$Data::Dumper::Indent = 1;
open(SU,'<',"sudoku.txt");

my $index  = 0;
my @curSudoku;
for ( <SU> ) {
	chomp;
	if (m/Grid (\d+)/ ) {
		$index = int($1);
	} else {
		push(@{$curSudoku[$index-1]},$_);
	}
}


my $unsolveable = 0;
my $runningTopLeftSum = 0;
for my $i (46,46,46,46,46,46) {
	print "On sudoku ".($i)."\n";
	#print Dumper ($curSudoku[$i]);
	my $s = createSudArray($curSudoku[$i]);
	$s = convertToSudObject($s);
	my $sclass = Sudoku->new('array'=> $s);
	# now we're an object
	$sclass->solve();

	#die;
#	printBox($sclass->getBox(0,1));
	if ( ! $sclass->isSolved() ) {
		print "Sudoku $i unsolveable\n";
		#print $sclass->toString();
		$unsolveable++;
		print "Attempting to use guess and check to solve\n";
		$sclass->guessAndCheck();
		if ( $sclass->isSolved ) {
			print "Yay $i solved using guess and check\n";
			$runningTopLeftSum += $sclass->getTopLeftSum;	
		} else {
			print "$i really unsolveable\n";
			print $sclass->toString();
		}
	} else {
		print "Sudoku $i solved\n";
		
		$runningTopLeftSum += $sclass->getTopLeftSum;
	}
	#print "Calling eliminateSolitaryBoxNumbers once\n";
	#print "Trying to solve sudoku $i\n";
	#solveSudoku ( $s );
	print "Running sum is $runningTopLeftSum\n";
}
print "$unsolveable are unsolveable\n";
print "Top left sum is $runningTopLeftSum\n";

sub getSolvedFromCol {
	my $col = shift;
	return getSolvedFromRow($col);
}

sub getSolvedFromRow {
	my $row = shift;

	my @solvedList;
	for (my $i = 0; $i < 9;$i++){
		if (scalar(@{$row->[$i]}) == 1 ) {
			push(@solvedList,$row->[$i][0]);
		}
	}
	#print Dumper(\@solvedList);
	return @solvedList;
}

sub getSolvedFromBox {
	my $box = shift;
	#print Dumper($box);
	my @solvedList;
	for (my $i = 0; $i < 3;$i++){
		for (my $j = 0; $j<3;$j++){
			if (scalar(@{$box->[$i][$j]}) == 1 ) {
				push(@solvedList,$box->[$i][$j][0]);
			}
		}
	}
	#print Dumper(\@solvedList);
	return @solvedList;
}

sub printBox {
	my $box = shift;

	for my $row (@{$box}) {
		for my $col ( @{$row} ) {
			print $col;
		}
		print "\n";
	}
}

sub boxElementIterator {
	my $box = shift;

	my @xs = (0,1,2,0,1,2,0,1,2);
	my @ys = (0,0,0,1,1,1,2,2,2);

	my $i = 0;
	my $j = 0;

    return sub {
    	if ( $i < 9 ) {
    		return $box->[$xs[$i++]][$ys[$j++]];
    	} else {
    		return undef;
		}
	};
}

sub createSudArray {
	my $arrayRef = shift;
	my @outputArray;
	for my $line (@{$arrayRef}) {
		my @nums = split(m//, $line);
		push(@outputArray,\@nums);
	}
	return \@outputArray;
}

sub convertToSudObject {
	my $sud = shift;

	for my $row (@{$sud}) {
		for my $el (@{$row}) {
			$el = int($el);
			if ( $el == 0 ) {
				$el = Set::Object->new(1..9);
			} else {
				$el = Set::Object->new($el);
			}
		}
	}
	return $sud;
}