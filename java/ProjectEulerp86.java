import java.util.*;
import java.math.*;
import java.io.*;

public class ProjectEulerp86 {
    
    public static void comb(int... items) {
        Arrays.sort(items);
        for (int k = 1; k <= items.length; k++) {
            kcomb(items, 0, k, new int[k]);
        }
    }
    public static void kcomb(int[] items, int n, int k, int[] arr) {
        if (k == 0) {
            System.out.println(Arrays.toString(arr));
        } else {
            for (int i = n; i <= items.length - k; i++) {
                arr[arr.length - k] = items[i];
                kcomb(items, i + 1, k - 1, arr);
            }
        }
    }
    
    public static void main(String... args) {
        // comb(1,2,3,4,5,7,8,9);
        kcomb(new int[] {1,2,3,4,5,6}, 0, 3, new int[3]);
        
        Set<Integer> perfectSquares = new HashSet<Integer>();
        for(int i = 0; i < 10000; i++) {
            perfectSquares.add(i*i);
        }
        
        int M = 99;
        int l = 1, w = 1, h = 1;
        int solutionCount = 0;
        boolean carry = false;
        
        int index = 2;
        while(true) {
            // System.out.println(String.format("%dx%dx%d",l,w,h));
            /*
            if(perfectSquares.contains(w*w + (l+h)*(l+h))) { 
                solutionCount++; 
                System.out.println(String.format("1 hlw %dx%dx%d",h,l,w));
            }
            if(perfectSquares.contains(l*l + (h+w)*(h+w))) { 
                solutionCount++; 
                System.out.println(String.format("2 hlw %dx%dx%d",h,l,w));
            }
            if(perfectSquares.contains(h*h + (l+w)*(l+w))) { 
                solutionCount++; 
                System.out.println(String.format("3 hlw %dx%dx%d",h,l,w));
            }
            */
            
            if(
                perfectSquares.contains(w*w + (l+h)*(l+h)) ||
                perfectSquares.contains(l*l + (h+w)*(h+w)) ||
                perfectSquares.contains(h*h + (l+w)*(l+w))
            ) { 
                solutionCount++; 
                System.out.println(String.format("1 lwh %dx%dx%d",l,w,h));
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
        
        System.out.println("Got " + solutionCount + " solutions for M = " + M);
    }
}