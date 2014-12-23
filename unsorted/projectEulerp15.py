import math

def paths(x, y):
    arr = [[-1 for i in range(x+1)] for j in range(y+1)]
    # print arr
    return paths_helper(x,y,arr)

def paths_helper(x, y, arr):
    if(x<1 or y<1):
        return 1
    if(arr[x][y] != -1):
        return arr[x][y]
    arr[x][y] = paths_helper(x-1,y,arr) + paths_helper(x,y-1,arr)
    return arr[x][y]

# Dynamic programming / memoziation solution
print "20,20: " + str(paths(20,20))

# Combinatorial solution
print str(math.factorial(20 + 20)/math.factorial(20)/math.factorial(20))