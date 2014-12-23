def sort(n):
    return ''.join(sorted(str(n)))

# First bucket the cubes by number of digits and then by the sorted version of those strings

max_digits = 15

length_bucket = [None] * max_digits
for x in range(1,10000):
    
    num = pow(x,3)
    length = len(str(num))
    sorted_num  = sort(num)

    if length_bucket[length] is None:
        length_bucket[length] = {}
    
    if length_bucket[length].get(sorted_num,None) is None:
        length_bucket[length][sorted_num] = set()
    
    length_bucket[length][sorted_num].add(num)
        
# Then iterate over the buckets to find the sets of size 5 

smallest_cubes = set()

for x in range(1,max_digits):
    if length_bucket[x] is None:
        continue
    for k in length_bucket[x].keys():
        s = length_bucket[x][k]
        if(len(s) == 5):
            print("For len %s, got perm set key %s with values %s" % (x, k, ','.join(str(e) for e in length_bucket[x][k])))
            smallest_cubes.add(min(s))
            
# The answer will be the smallest cube from each of the sets with 5 permutations
print("The smallest cube with five permutations that are also cubes is %s" % (str(min(smallest_cubes))))
