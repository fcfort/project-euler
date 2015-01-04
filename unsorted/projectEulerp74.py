import math

factorial_memo = {}
def factorial(k):
    if k < 2: return 1
    if k not in factorial_memo:
        factorial_memo[k] = math.factorial(k)
    return factorial_memo[k]

next_digital_factorial_memo = {}
def next_digital_factorial(n):
    if n not in next_digital_factorial_memo:
        sum = 0
        for x in list(str(n)):
            sum += factorial(int(x))
        next_digital_factorial_memo[n] = sum
    return next_digital_factorial_memo[n]

def get_loop_size(n):
    loop_map = {}
    prev = n
    while prev not in loop_map:
        loop_map[prev] = next_digital_factorial(prev)
        prev = loop_map[prev]
    return len(loop_map)

count = 0
for x in range(1,1000000):
    loop_size = get_loop_size(x)
    if loop_size == 60:
        count += 1
        print "Got loop size of %d for number %d" % (loop_size,x)
print "Got %d loops of size 60" % (count)