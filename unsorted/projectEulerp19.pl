#!/usr/bin/perl.exe -w
use Data::Dumper;

my $month = 0;
my $year = 1900;
my $day = 0; #  0==Monday, Sunday == 6
my $sundays = 0;

my @months = (
#J,F,Ma,Ap,My,Ju,Jy,Au,Sp,Oc,Nv,De
31,0,31,30,31,30,31,31,30,31,30,31
);
my @days = (
'Mo','Tu','We','Th','Fr','Sa','Su'
);

while($year < 2001) {

	print "($day)".($days[$day % 7])."-". ($month+1) . "-$year ";
	if ( $day % 7 == 6 ) {
		if ( $year != 1900 ) {
			$sundays++;
		}
	}

	if ( $month == 1 ) { #feb
		if (
			(($year % 4 == 0) && 
			($year % 100 != 0)) || 
			($year % 400 == 0)
			) 
		{
			$day += 29;
			print "\nLeap year $year\n";
		} else 
		{
	 		$day += 28;
	 	}
	}
	else {		
		$day += $months[$month];
	}

	$month++;
	if ( $month > 11 ) {
		$month = 0;
		$year++;
		#print "$year ";;
	}
}

print "Found $sundays sundays\n";