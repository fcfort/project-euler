import java.util.*;

/**
 * Very similar to problem 76 except with the use of primes as subtrahends 
 * instead of counting numbers. The only tricky part is that there is a new
 * base case, in which we cannot reach zero for a given number. In this instance
 * we don't increase the count, returning zero instead.
 * 
 * Prime listing function is memoized.
 */
public class ProjectEulerp77 {
       
    private static Map<Integer, BitSet> primes_memo = new HashMap<Integer, BitSet>();
       
    /**
     * maxs_sub represents the largest number we are allowed to subtract
     * from our current i. This is to prevent double counting of different branches
     * by only allowing monotonically decreasing subtractions.
     */
    private static int _sums(int i, int max_sub) {
        // Unable to reach zero for this call
        if(i < 0 ) { return 0; }
        // Got to exactly zero for this call
        if(i == 0) { return 1; }
        
        int count = 0;
    
        // Subtract primes up to the max subtrahend
        for(int p : computePrimes(max_sub)) {
            // System.out.println(String.format("Calling _sums(%d - %d, %d) or _sums(%d, %d)", i, p, p, i - p, p));
            count += _sums(i - p, p);
        }
        
        return count;
    }
    
    public static int sums(int i) {
        return _sums(i, i - 1);
    }
    
    /** Memoized */
    private static int[] computePrimes(int limit) {
        if(!primes_memo.containsKey(limit)) {
            primes_memo.put(limit, _computePrimes(limit));
        } 
        
        return bitsToList(primes_memo.get(limit));
    }
    
    /**
     * Returns as a BitSet the primes <= limit
     * Taken from http://stackoverflow.com/a/1043247 and expanded to include
     * primes <= limit instead of primes < limit
     */
    private static BitSet _computePrimes(int limit) {
        final BitSet primes = new BitSet();
    
        primes.set(0, false);
        primes.set(1, false);
        primes.set(2, true);
        
        if(limit <= 2) { return primes; }
        
        primes.set(3, limit + 1, true);
    
        //System.out.println("With limit " + limit + " : " + primes);
        
        for(int i = 0; i * i <= limit; i++) {
            if (primes.get(i)) {
                for(int j = i * i; j <= limit; j += i) {
                    primes.clear(j);
                }
            }
        }
        
        return primes;
    }
    
    // Converts the BitSet to an iterable
    private static int[] bitsToList(BitSet b) {
        int[] setBits = new int[b.cardinality()];
        int bit_index = 0;
        
        for (int i = b.nextSetBit(0); i >= 0; i = b.nextSetBit(i+1)) {
            setBits[bit_index++] = i;
        }
        
        return setBits;
    }
    
    public static void main(String... args) {
        // Iterate through numbers until we get to a count of over 5000
        int i = 10;
        while(true) {
            if(sums(i) > 5000) {
                System.out.println(i + " : " + sums(i));
                break;
            }
            i++;
        }
    }
    
}