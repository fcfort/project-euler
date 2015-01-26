import random

# prime functions from http://phillipmfeldman.org/mathematics/primes
def miller_rabin_pass(a, s, d, n):
    a_to_power = pow(a, d, n)
    if a_to_power == 1:
        return True
    for i in xrange(s-1):
        if a_to_power == n - 1:
            return True
        a_to_power = (a_to_power * a_to_power) % n
    return a_to_power == n - 1


def is_prime2(n):
   """
   This function implements the Miller-Rabin primality test for integers n >= 3.
   This is a probabilistic test of primality, i.e., it can return a false
   positive result, although the probability of such an error is extremely low.
   A return value of False means that n is definitely not prime.
   This function was taken from the following source, and is reproduced with the
   copyright notice from that source.

   Copyright (c) 2013 the authors listed at the following URL, and/or
   the authors of referenced articles or incorporated external code:
   http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
   """

   d = n - 1
   s = 0
   while d % 2 == 0:
       d >>= 1
       s += 1

   for repeat in xrange(20):
       a= random.randrange(1, n)
       if not miller_rabin_pass(a, s, d, n):
           return False
   return True
   
# Each of the four diagonal values is related by the perimeter one must trace around the
# previous numbers to reach the next number. This is roughly related by the layer number
# (where the starting number of "1" is layer zero) and multiplying that number by the length
# and width of the numbers before it.
# 
# So for example, the recurrence relation for the NW diagonal is: 
# 
# diagonal_NW(n) = diagonal_NW(n-1) + 2*(2*(n-1)) + 2*(2*n)
#
# We can define each of the four diagonals (NE, NW, SW, SE)
# going clockwise in terms of these recurrence relations:
#   NE: f(n) = f(n-1) + 8n - 6
#   NW: f(n) = f(n-1) + 8n - 4
#   SW: f(n) = f(n-1) + 8n - 2
#   SE: f(n) = f(n-1) + 8n
# 
# Rewriting these in terms of a closed formula can be done by observing that
# recurrence relations of the form above can be rewritten to the form:
#
# f(n) = a * r ^ n + b * n
#
# Doing so gives us:
#
#   NE: f(n) = 2^(2n+1) - 6n
#   NW: f(n) = 2^(2n+1) - 4n
#   SW: f(n) = 2^(2n+1) - 2n
#   SE: f(n) = 2^(2n+1)
# 

def diagonal_ne(n):
    return pow(2*n+1,2) - 6*n
    
def diagonal_nw(n):
    return pow(2*n+1,2) - 4*n
    
def diagonal_sw(n):
    return pow(2*n+1,2) - 2*n
    
def diagonal_se(n):
    return pow(2*n+1,2)

prime_count = 0
layer_count = 1

# Now, we use a primality test upon each closed-form diagonal function
# to determine when the ratio falls before 10%

while True:
    if(is_prime2(diagonal_ne(layer_count))):
        prime_count += 1
    if(is_prime2(diagonal_nw(layer_count))):
        prime_count += 1
    if(is_prime2(diagonal_se(layer_count))):
        prime_count += 1
    if(is_prime2(diagonal_sw(layer_count))):
        prime_count += 1
    
    if(prime_count/(4*float(layer_count)) < 0.10):
        break
    
    print str(prime_count/(4*float(layer_count)))
    
    layer_count += 1


# Then we calculate what the side length would be for the given layer
# count that we stopped at:
print "The final side length is " + str(layer_count*2 - 1)