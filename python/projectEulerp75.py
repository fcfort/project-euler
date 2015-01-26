# encoding=utf-8
# http://en.wikipedia.org/wiki/Pythagorean_triple
# Pythagorean triples can be generated via:
#  a = k * (m^2 - n^2), b = k*(2mn), c = k*(m^2 + n^2)
# where m, n, and k are positive integers with m > n, m − n odd, and with m and
# n coprime

# Coprime m and n can be generated via the Farey sequence from problem 73.
# Adapted from http://www.wikiwand.com/en/Farey_sequence
def farey(n):
    """Python function to print the nth Farey sequence, either ascending or descending."""
    a, b, c, d = 0, 1,  1  , n     # (*)
    while c <= n:
        k = int((n + b)/d)
        a, b, c, d = c, d, k*c - a, k*d - b
        if (max(a,b) - min(a,b)) % 2 == 0:
            continue # m - n must be odd
        yield (max(a,b),min(a,b))

perimeter_dict = {}

# The perimeter for a given coprime is given by
# p = a + b + c
# ...
# p = 2km^2 + 2kmn
# 
# The largest farey sequence we need to iterate over is one such that the 
# perimeter does not exceed 1,500,000
# The largest perimeter for a given farey(n) is the coprimes of n and 1
# So we only need to iterate up to n such that
# 2n(n+1) < 1,500,000
# n^2 + n < 750,000
# Solving this gives us 
# n <= 866
for (m,n) in farey(866):
    k = 1
    while 2*k*m*(m + n) <= 1500000:
        perimeter = 2*k*m*(m + n)
        if perimeter not in perimeter_dict:
            perimeter_dict[perimeter] = 1
        else:
            perimeter_dict[perimeter] += 1
        k += 1        

print "Done iterating through coprimes"

count = 0
for k,v in perimeter_dict.iteritems():
    if v == 1:
        count += 1

print "Got %d perimeters such that only one triangle can be made" % (count)