/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package projecteuler;

import java.math.BigInteger;

/**
 *
 * @author fe01106
 */
public class P85 {

	public static BigInteger numRectangles (int width, int height) {
		//System.out.println("width " + width);
		BigInteger total = new BigInteger("0");
		for(int a=1; a<=width; a++) {
			for(int b=1;b<=height;b++){
				total = total.add( 
					new BigInteger(
						new Integer(
							(width-a+1)*(height-b+1)
						).toString()
					)
				);
				
			}
		}
		return total;
	}
	
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
		BigInteger l = new BigInteger("1999000");
		//BigInteger g = new BigInteger("2000000");
		BigInteger num = new BigInteger("2000000");
		for(int i=0;i<200;i++) {
			for(int j=0;j<i;j++){
				BigInteger t = numRectangles(i,j);
				if ( t.compareTo(num) >= 0) {
					continue;		
				}
				if ( t.compareTo(l) > 0) {
					System.out.println(t + " "+i+" "+j);
				}
				
			}		
		}
		
		
    }

}
