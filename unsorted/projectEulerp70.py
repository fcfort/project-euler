#coding=utf-8

from decimal import *
import timeit, math
from prime_decomposition import decompose

# http://www.wikiwand.com/en/Euler%27s_totient_function
def euler_totient(n):
    
    result = Decimal(n)
    
    for p in set(decompose(n)):
        factor = 1 - 1/Decimal(p)
        result *= factor
    
    return int(result)
    
# non-Decimal version
def euler_totient_float(n):
    result = n
    
    for p in set(decompose(n)):
        result *= 1 - 1/float(p)
    
    return int(round(result))

def is_permutation(a,b):
    return sorted(str(a)) == sorted(str(b))

def is_permutation_len(a,b):
    str_a = str(a)
    str_b = str(b)
    
    return len(str_a) == len(str_b) and sorted(str_a) == sorted(str_b)
    
# Find the value of n, 1 < n < 10**7, for which φ(n) is a permutation of n and the ratio n/φ(n) produces a minimum.
def find_euler_perms(n):
    
    min_ratio = 100000
    min_ratio_n = 1
    
    for x in range(2,n - 1):
        factors = list(decompose(x))
        if len(factors) == 2:
            p = factors[0]
            q = factors[1]
            prime_factor_ratio = (1 - 1/float(p))*(1 - 1/float(q))
            # totient = euler_totient_float(x)
            totient = int(round(x*prime_factor_ratio))
            ratio = x / float(totient)
            
            if is_permutation(x,totient) and ratio < min_ratio:
                min_ratio = ratio
                min_ratio_n = n
                print "Got new min ratio n " + str(x) + " for ratio " + str(ratio)


find_euler_perms(10**7)
# 10,000,000