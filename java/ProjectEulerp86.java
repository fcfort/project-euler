import java.util.HashSet;
import java.util.Set;

/** 
 * Very slowwww solution that takes a couple of minutes to find the solution.
 * Doesn't attempt to increment from the previous solutions and blindly retries
 * all previous numbers for every new cuboid size M.
 * 
 * The solution is seeing that the shortest path across a cuboid of size l*w*h
 * must be a straight line across two faces of the cuboid. Since there are three
 * possible paths across the cuboid, we must take the minimum of those lengths
 * and then see if that number is an integer.
 */
public class ProjectEulerp86 {

    private static Set<Integer> PERFECT_SQUARES = new HashSet<Integer>();
    
    static {
        for(int i = 0; i < 10000; i++) {
            PERFECT_SQUARES.add(i*i);
        }
    }

    public static int countSolutions(int M) {
        int l = 1, w = 1, h = 1;
        int solutionCount = 0;
        
        while(true) {
            int minLengthSquared = Math.min(
                w*w + (l+h)*(l+h),Math.min(
                l*l + (h+w)*(h+w),
                h*h + (l+w)*(l+w)
            ));
            
            if(PERFECT_SQUARES.contains(minLengthSquared)) { 
                solutionCount++; 
            }
            
            h++;
            if(h > M) {
                w++;
                h = w;
                if(w > M) {
                    l++;
                    h = l;
                    w = l;
                    
                    if(l > M) {
                        break;
                    }
                }
            }
            
        }
        
        return solutionCount;
    }

    public static void main(String... args) {
    	
        int M = 1800;
        int incrementRate = 10;        
        while(true) {
            int solns = countSolutions(M);
            System.out.println("Got " + solns + " solutions for M = " + M);
                   
            if(solns > 1000000) {
            	if(incrementRate > 1) {
            		M -= incrementRate;
            		incrementRate >>= 1;
            		incrementRate = incrementRate < 1 ? 1 : incrementRate; 
            	} else {
            		break;
            	}
            } else {
            	M += incrementRate;
            }
            
        }
    }
}