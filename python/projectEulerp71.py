import math
from decimal import *
getcontext().prec = 28

frac = 3/Decimal(7)

def find_fraction(d):
    min_error = 1
    min_numerator = 1
    
    for denom in reversed(range(2,d)):
        if denom % 7 != 0:
            numerator = (frac * denom).to_integral_value(rounding=ROUND_FLOOR)
            err = frac - numerator/Decimal(denom)
            if err < min_error:
                min_error = err
                min_numerator = numerator
                print "for numerator %d denom %d, got err %f" % (numerator, denom ,err)
        
# Searches for the largest denominator such that the numerator / denominator is less
# than seven and minimizes the error between that fraction and the fraction 3/7. 
find_fraction(1000000)