import java.util.*;
import java.math.*;

public class ProjectEulerp78 {

    private static Map<Integer, BigInteger> memo = new HashMap<Integer, BigInteger>();
    
    private static final BigInteger NEGATIVE_ONE = new BigInteger("-1");
    private static final BigInteger ONE_MILLION = new BigInteger("1000000");

    /** Memoized partition function */
    public static BigInteger _part(int n) {
        if(!memo.containsKey(n)) {
            memo.put(n,partition(n));
        }
        
        return memo.get(n);
    }

    public static BigInteger partition(int n) {
        if(n < 0) { return BigInteger.ZERO; }
        if(n == 0) { return BigInteger.ONE; } 
        
        BigInteger p = BigInteger.ZERO;

        for(int i = 1; generalizedPentagonalNumber(i) <= n; i++) {
            // Get an index into the pentagonal series
            int offset = generalizedPentagonalNumber(i);
            
            // Calculate whether to add or subtract term
            BigInteger sign = NEGATIVE_ONE.pow((i - 1)/2);
            
            // Calculate that terms value
            BigInteger term = _part(n - offset);
            
            // And add/subtract mod 1,000,000 so the numbers stay small
            p = p.add(term.multiply(sign)).mod(ONE_MILLION);
        }
        
        // Mod 1,000,000 so the numbers stay small
        return p.mod(ONE_MILLION);
        
    }
    
    public static int pentagonalNumber(int m) {
        return (3*m*m-m)/2;
    }
    
    public static int generalizedPentagonalNumber(int m) {
        int generalized_pent_index = (m + 1)/2;
        if(m % 2 == 0) { generalized_pent_index *= -1; }
        
        return pentagonalNumber(generalized_pent_index);
    }
    
    public static void main(String... args) {     
        int j = 0;
        while(true) {
            BigInteger count = partition(j);
            
            if(j % 100 == 0) {
                System.out.println(j + " : " + count);
            }
            
            if(count.mod(ONE_MILLION).equals(BigInteger.ZERO)) {
                System.out.println(String.format("Answer = %d. Count is %d", j, count));
                break;
            }
            
            j++;
        }
    }
}