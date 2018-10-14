import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Random;
import java.util.Set;

/**
 * Solved by simulating a monopoly piece moving around the board and keeping a
 * running tally of where the piece ended after a single turn.
 * 
 * Based on work from http://www.tkcs-collins.com/truman/monopoly/monopoly.shtml#Markov
 *     0    1   2   3   4   5   6   7   8   9   10
 *     GO	A1	CC1	A2	T1	R1	B1	CH1	B2	B3	JAIL 
    39 H2	 	                                  C1 11
    38 T2	 	                                  U1 12
    37 H1	 	                                  C2 13
    36 CH3	 	                                  C3 14
    35 R4	 	                                  R2 15
    34 G3	 	                                  D1 16
    33 CC3	 	                                  CC2 17
    32 G2	 	                                  D2 18
    31 G1	 	                                  D3 19
       G2J	F3	U2	F2	F1	R3	E3	E2	CH2	E1	  FP 20
       30   29  28  27  26  25  24  23  22  21
 * 
 */
public class ProjectEulerp84 {
    
    /** Found at indexes 2,17,34 */
    public enum CommunityChestCard {
        ADVANCE_TO_GO(0),
        JAIL(10),
        NO_OP;
                
        private final int location;
        
        CommunityChestCard() { location = -1; }
        CommunityChestCard(int location_) { location = location_; }
        
        public int location() { return location; }
    }
    
    /** Found at indexes 7,22,37 */
    public enum ChanceCard {
        ADVANCE_TO_GO(0), //Advance to GO
        JAIL(10), // Go to JAIL
        C1(11), // Go to C1
        E3(24), // Go to E3
        H2(39), // Go to H2
        R1(5), // Go to R1
        NEXT_RR, // Go to next R (railway company)
        NEXT_UTIL, // Go to next U (utility company)
        BACK_3, // Go back 3 squares.
        NO_OP;
        
        private final int location;
        
        ChanceCard() { location = -1; }
        ChanceCard(int location_) { location = location_; }
        
        public int location() { return location; }
    }
    
    private static final int MONOPOLY_BOARD_SIZE = 40;
    private static final int CARD_COUNT = 16;
    private static final int JAIL_LOC = 10;
    private static final int GO_TO_JAIL_LOC = 30;
    private static final Set<Integer> CHANCE_LOCATIONS = new HashSet<Integer>(Arrays.asList(7,22,37));
    private static final Set<Integer> COMMUNITY_CHEST_LOCATIONS = new HashSet<Integer>(Arrays.asList(2,17,34));
    private static final int[] RR_LOCATIONS = new int[] {5, 15, 25, 35};
    private static final int[] UTIL_LOCATIONS = new int[] {12, 28};
    private final Queue<CommunityChestCard> communityChestCards;
    private final Queue<ChanceCard> chanceCards;
    private final Random r;
    
    private final int diceSize; // e.g. number of sides
    
    public ProjectEulerp84(int diceSize_) {
        diceSize = diceSize_;
        communityChestCards = initializeCommunityChest();
        chanceCards = initializeChance();
        r = new Random(0);
    }
    
    /**Community Chest (2/16 cards):
        Advance to GO
        Go to JAIL
    */
    private Queue<CommunityChestCard> initializeCommunityChest() {
        LinkedList<CommunityChestCard> t = new LinkedList<CommunityChestCard>();
        
        t.add(CommunityChestCard.ADVANCE_TO_GO);
        t.add(CommunityChestCard.JAIL);
        
        for(int i = 0; i < CARD_COUNT - 2; i++) {
            t.add(CommunityChestCard.NO_OP);
        }
        
        Collections.shuffle(t);
        
        return t;
    }
    
    /** Chance (10/16 cards):
        Advance to GO
        Go to JAIL
        Go to C1
        Go to E3
        Go to H2
        Go to R1
        Go to next R (railway company)
        Go to next R
        Go to next U (utility company)
        Go back 3 squares.
    */
    private Queue<ChanceCard> initializeChance() {
        LinkedList<ChanceCard> t = new LinkedList<ChanceCard>();
        
        t.add(ChanceCard.ADVANCE_TO_GO);
        t.add(ChanceCard.JAIL);
        t.add(ChanceCard.C1);
        t.add(ChanceCard.E3);
        t.add(ChanceCard.H2);
        t.add(ChanceCard.R1);
        t.add(ChanceCard.NEXT_RR);
        t.add(ChanceCard.NEXT_RR);
        t.add(ChanceCard.NEXT_UTIL);
        t.add(ChanceCard.BACK_3);
        
        for(int i = 0; i < CARD_COUNT - 10; i++) {
            t.add(ChanceCard.NO_OP);
        }
        
        Collections.shuffle(t);
        
        return t;
    }
    
    // Given a starting position, return the resulting positon after one roll
    public int roll(int startingLocation) {
        return roll(startingLocation, 0);
    }
    
    // Process rolls while holding state for how many doubles have been rolled
    public int roll(int startingLocation, int doubleCount) {
        int location = startingLocation;
        
        // Roll dice 
        int die_1 = r.nextInt(diceSize) + 1;
        int die_2 = r.nextInt(diceSize) + 1;
        
        // If we roll three doubles, immediately go to jail
        if(die_1 == die_2 && doubleCount == 2) {
            return JAIL_LOC;
        }
        
        // Else move the piece
        location = (location + die_1 + die_2) % MONOPOLY_BOARD_SIZE;
        
        // Check for CC, chance, G2J locations
        if(COMMUNITY_CHEST_LOCATIONS.contains(location)) {
            location = doCommunityChest(location);
        } else if(CHANCE_LOCATIONS.contains(location)) {
            location = doChance(location);
        } 
        
        if(location == GO_TO_JAIL_LOC) {
            location = JAIL_LOC;
        }
        
        // If we did roll a double, roll again, incrementing our double count
        if(die_1 == die_2) {
            return roll(location, doubleCount + 1);
        }
        
        // Else return where we ended up
        return location;
    }
    
    /** Calculate chance movements */
     private int doChance(int location) {
        ChanceCard c = chanceCards.remove();
        chanceCards.add(c);
        
        switch(c) {
			case ADVANCE_TO_GO:
			case C1:
			case E3:
			case H2:
            case R1:
			case JAIL:
			    return c.location();
			case NEXT_RR:
			    if(location > RR_LOCATIONS[3]) { return RR_LOCATIONS[0]; }
			    
			    for(int rrLocation : RR_LOCATIONS) {
			        if(rrLocation > location) { return rrLocation; }
			    }
			    
			    throw new RuntimeException();
			case NEXT_UTIL:
			    if(location > UTIL_LOCATIONS[1]) { return UTIL_LOCATIONS[0]; }
			    else if(location > UTIL_LOCATIONS[0]) { return UTIL_LOCATIONS[1]; }
			    else { return UTIL_LOCATIONS[0]; }
			case BACK_3:
			    if(COMMUNITY_CHEST_LOCATIONS.contains(location - 3)) {
			        return doCommunityChest(location - 3);
			    } else {
			        return location - 3;
			    }
			case NO_OP:
				return location;
			default:
				throw new RuntimeException();           
        }
     }
    
    /** Calculate community chest movements */
    private int doCommunityChest(int location) {
        CommunityChestCard c = communityChestCards.remove();
        communityChestCards.add(c);
        
        switch(c) {
			case ADVANCE_TO_GO:
			case JAIL:
			    return c.location();
			case NO_OP:
			    return location;
			default:
			    throw new RuntimeException();
        }
    }    
    
    /** Keep going from the starting location and return a matrix of probabilities
     * for end at that location
     */
    public double[] simulateRollsSingle(int startingLocation, int rounds) {
        int[] resultCount = new int[MONOPOLY_BOARD_SIZE];
        
        int location = 0;
        
        for(int i = 0; i < rounds; i++) {
            location = roll(location);
            resultCount[location]++;
        }
        
        double[] resultFraction = new double[MONOPOLY_BOARD_SIZE];
        
        for(int i = 0; i < MONOPOLY_BOARD_SIZE; i++) {
            resultFraction[i] = (double)resultCount[i]/rounds;
        }
        
        return resultFraction;
    }
    
    /** For sorting only */
    public static class Position implements Comparable<Position> {
    	public int loc;
    	public double frac;    	
    	Position(int loc_, double frac_) { loc = loc_; frac = frac_; }
		@Override public int compareTo(Position o_) { return Double.compare(o_.frac, frac); }
		@Override public String toString() { return String.format("Position[%d -> %f]", loc, frac); }
    }   
    
    public static void main(String... args) {
        ProjectEulerp84 p = new ProjectEulerp84(4);
        
        // Simulate a lot of rolls
        double[] results = p.simulateRollsSingle(0, 100000000);
        
        System.out.println(Arrays.toString(results));
        System.out.println("Probability array : " + Arrays.toString(results));
        
        // Sort to get top three positions
        List<Position> sort = new ArrayList<Position>();
        int j = 0;
        for(double frac : results ) {
        	sort.add(new Position(j++, frac));
        }
        Collections.sort(sort);
        System.out.println("Top three spots: " + sort.get(0) + " " + sort.get(1) + " " + sort.get(2) + " ");
        System.out.println("Modal string for those positions is " + String.format("%02d%02d%02d", sort.get(0).loc, sort.get(1).loc, sort.get(2).loc)); 
    }
}
