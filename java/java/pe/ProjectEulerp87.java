import java.util.Arrays;
import java.util.BitSet;

/**
 * Iterates through all possible primes that could possibly add to 50,000,000
 * and maintains which ones it has found so far. Then we only return those
 * solutions less than 50,000,000
 */
public class ProjectEulerp87 {
    // Converts the BitSet to an iterable
    private static int[] bitsToList(BitSet b) {
        int[] setBits = new int[b.cardinality()];
        int bit_index = 0;
        
        for (int i = b.nextSetBit(0); i >= 0; i = b.nextSetBit(i+1)) {
            setBits[bit_index++] = i;
        }
        
        return setBits;
    }
    
    /**
     * Returns as a BitSet the primes <= limit
     * Taken from http://stackoverflow.com/a/1043247 and expanded to include
     * primes <= limit instead of primes < limit
     */
    private static int[] computePrimes(int limit) {
        final BitSet primes = new BitSet();
    
        primes.set(0, false);
        primes.set(1, false);
        primes.set(2, true);
        
        if(limit <= 2) { return bitsToList(primes); }
        
        primes.set(3, limit + 1, true);
    
        //System.out.println("With limit " + limit + " : " + primes);
        
        for(int i = 0; i * i <= limit; i++) {
            if (primes.get(i)) {
                for(int j = i * i; j <= limit; j += i) {
                    primes.clear(j);
                }
            }
        }
        
        return bitsToList(primes);
    }
	
    public static int countSolutions(int M) {
    	int xMax = (int) Math.pow(M, (double)1/2) + 1;
    	int yMax = (int) Math.pow(M, (double)1/3) + 1;
    	int zMax = (int) Math.pow(M, (double)1/4) + 1;
    	
    	System.out.println(String.format("For M = %d, got max values x = %d, y = %d, z = %d", M, xMax, yMax, zMax));    	     
                    
        int[] xPrimes = computePrimes(xMax);
        System.out.println(String.format("Got %d primes up to %d: %s", xPrimes.length, xPrimes[xPrimes.length - 1], Arrays.toString(xPrimes)));
        
        int[] yPrimes = computePrimes(yMax);
        System.out.println(String.format("Got %d primes up to %d: %s", yPrimes.length, yPrimes[yPrimes.length - 1], Arrays.toString(yPrimes)));
        
        int[] zPrimes = computePrimes(zMax);
        System.out.println(String.format("Got %d primes up to %d: %s", zPrimes.length, zPrimes[zPrimes.length - 1], Arrays.toString(zPrimes)));
                
        int xIndex = 0, yIndex = 0, zIndex = 0;
        BitSet b = new BitSet();
        
        while(true) {
        	int x = xPrimes[xIndex];
        	int y = yPrimes[yIndex];
        	int z = zPrimes[zIndex];
        	
        	int soln = x*x + y*y*y + z*z*z*z;
        	
            b.set(soln);
            zIndex++;
            if(zIndex > zPrimes.length - 1) {
                yIndex++;
                zIndex = 0;
                if(yIndex > yPrimes.length - 1) {
                    xIndex++;
                    yIndex = 0;
                    zIndex = 0;                    
                    if(xIndex > xPrimes.length - 1) {
                        break;
                    }
                }
            }            
        }
        
        return b.get(0, M).cardinality();
    }

    public static void main(String... args) { 
    	 System.out.println(countSolutions(50000000));
    }
}