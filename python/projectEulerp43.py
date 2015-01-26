import itertools


# Here nothing is set
def getDigits(strings,digits,digits_left):
    # 2
    for x in [0,2,4,6,8]:
        d = digits[:]
        d[3] = x
        test_3(strings, d, digits_left - set([x]))
    return strings
    
# Here d4 is set
def test_3(strings, digits, digits_left):
    # 3
    #print digits, digits_left
    for x in itertools.permutations(digits_left,2):
        if((x[0] + x[1] + digits[3]) % 3 == 0):
            d = digits[:]
            d[2] = x[0]
            d[4] = x[1]
            test_5(strings, d, digits_left - set([d[2],d[4]]))
    return strings

# Here d3 to d5 are set
def test_5(strings, digits, digits_left):
    #print digits, digits_left
    # 5
    
    for x in set([0,5]) & digits_left:
        #print digits, digits_left, x
        d = digits[:]
        d[5] = x
        test_7(strings, d, digits_left - set([x]))
    return strings

# Here d3 - d6 are set
def test_7(strings, digits, digits_left):
    #print digits, digits_left
    # 7 
    
    for x in digits_left:
        if((digits[4]*10 + digits[5] - 2 * x) % 7 == 0):
            d = digits[:]
            d[6] = x
            test_11(strings, d, digits_left - set([x]))
    return strings
            
# Here d3 - d7 are set
def test_11(strings, digits, digits_left):
    # 11
    #print digits
    for x in digits_left:
        if((digits[6] - (digits[5] + x)) % 11 == 0):
            d = digits[:]
            d[7] = x
            test_13(strings, d, digits_left - set([x])) 
    return strings

# Here d3 - d8 are set
def test_13(strings, digits, digits_left):
    # 13 
    for x in digits_left:
        if((digits[6]*100 + digits[7]*10 + x) % 13 == 0):
            d = digits[:]
            d[8] = x
            test_17(strings, d, digits_left - set([x]))
    return strings

# Here d3 - d9 are set
def test_17(strings, digits, digits_left):
    # 17
    for x in digits_left:
        if((digits[7]*10+digits[8] - 5*x) % 17 == 0):
            d = digits[:]
            d[9] = x
            test_remaining_digits(strings, d, digits_left - set([x]))
    return strings
            
def test_remaining_digits(strings, digits, digits_left):
    print digits, digits_left
    for x in itertools.permutations(digits_left):
        d = digits[:]
        d[0] = x[0]
        d[1] = x[1]
        strings.add("".join(map(str,d)))
    return strings
    
strings = getDigits(set([]),  [-1] * 10, set(range(10)))

for x in sorted(strings):
    print x

print "The answer is ", sum(map(int,strings))
