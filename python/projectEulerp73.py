#coding=utf-8
from prime_decomposition import decompose, is_prime
# Consider the fraction, n/d, where n and d are positive integers. If n<d and HCF(n,d)=1, it is called a reduced proper fraction.
# If we list the set of reduced proper fractions for d ≤ 8 in ascending order of size, we get:
# 1/8, 1/7, 1/6, 1/5, 1/4, 2/7, 1/3, 3/8, 2/5, 3/7, 1/2, 4/7, 3/5, 5/8, 2/3, 5/7, 3/4, 4/5, 5/6, 6/7, 7/8
# It can be seen that there are 3 fractions between 1/3 and 1/2.
# How many fractions lie between 1/3 and 1/2 in the sorted set of reduced proper fractions for d ≤ 12,000?

# Adapted from http://www.wikiwand.com/en/Farey_sequence
def farey( n, lower_bound, upper_bound):
    """Python function to print the nth Farey sequence, either ascending or descending."""
    a, b, c, d = 0, 1,  1  , n     # (*)
    count = 0
    while (c <= n):
        k = int((n + b)/d)
        a, b, c, d = c, d, k*c - a, k*d - b
        if a/float(b) > lower_bound and a/float(b) < upper_bound:
            count += 1
    return count
        
# We can iterate through the Farey sequence (http://www.wikiwand.com/en/Farey_sequence) and count
# when the fractions generated are between our bounds        
print farey(12000, 1/float(3), 1/float(2))