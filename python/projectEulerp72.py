from prime_decomposition import decompose, is_prime
from prime_test import is_prime2

# For any given denominator d, only those fractions in which either the numerator
# and the denominator are co-prime will result in a unique reduced fraction. For this problem
# we explicitly exclude d/d always. Each denominator d has atmost d - 1 unique 
# irreducible fractions.

# non-Decimal version
def euler_totient_float(n):
    result = n
    
    for p in set(decompose(n)):
        result *= 1 - 1/float(p)
    
    return int(round(result))

def count_distinct_fractions(n):
    # Case 1: n is prime.
    # All of its fractions must be unique
    if is_prime2(n):
        return n - 1
    # Case 2: n is not prime.
    # All numerators which are co-prime with the denominator are irreducible.
    # This is equal to the Euler totient function
    else:
        return euler_totient_float(n)

sum = 0
for x in range(2,1000000 + 1):
    sum += count_distinct_fractions(x)
print "Got sum %d" % (sum)
    
