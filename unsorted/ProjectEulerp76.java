import java.util.*;

/**
 * Solved by observing that we can ask the same question but phrased in terms
 * of subtractions. Then we have to iterate over how many ways we can subtract
 * a number for a given number of n. We must also be sure to only count monotonically
 * decreasing subtrahends. In this way we ensure that we don't double count 
 * different ways of getting the same set of ub subtrahends.
 * 
 * E.g.
 *   Don't allow
 *      5 - 2 = 3, 3 - 2 = 0 AND
 *      5 - 3 = 2, 2 - 2 = 0.
 * 
 * Could have memoized this but n = 100 completed in under a minute.
 */
public class ProjectEulerp76 {
    
    /**
     * maxs_sub represents the largest number we are allowed to subtract
     * from our current i. This is to prevent double counting of different branches
     * by only allowing monotonically decreasing subtractions.
     */
    private static int _sums(int i, int max_sub) {
        if(i == 0) { return 1; }
        
        int count = 0;
        
        for(int sub = 1; sub <= i && sub <= max_sub; sub++) {
            // System.out.println(String.format("Calling _sums(%d - %d, %d) or _sums(%d, %d)", i, sub, sub, i - sub, sub));
            count += _sums(i - sub, sub);
        }
        
        return count;
    }
    
    public static int sums(int i) {
        return _sums(i, i - 1);
    }
    
    public static void main(String... args) {
        
        for(int i : new int[] {1, 2, 3, 4, 5, 100}) {
            System.out.println(i + " : " + sums(i));
        }
    }
}