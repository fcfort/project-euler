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