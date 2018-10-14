import java.util.*;
import java.io.*;

/**
 * Graph and algorithm code from http://www.keithschwarz.com/interesting/
 * 
 * Very similar to P82, except with more edges possible
 */
public class ProjectEulerp83 {
    
    public static class Node {
        int i,j;
        public Node() {}
        public Node(int i_, int j_) { i = i_; j = j_; }
    }

    private static int calculateMinCost(int[][] arr) {
        int MATRIX_SIZE = arr.length;
        
        DirectedGraph<Node> g = new DirectedGraph<Node>();
        
        Node[][] nodes = new Node[MATRIX_SIZE][MATRIX_SIZE];
        
        // Create all the nodes
        for(int i = 0; i < arr.length; i++) {
            for(int j = 0; j < arr[i].length; j++) {
                nodes[i][j] = new Node(i,j);
                g.addNode(nodes[i][j]);
            }
        }
        
        for(int i = 0; i < MATRIX_SIZE; i++) {
            System.out.println(String.format("Adding nodes for row %d", i));
            for(int j = 0; j < MATRIX_SIZE - 1; j++) {
                // Add the upper element to the graph
                if(i != 0) {
                    g.addEdge(nodes[i][j], nodes[i-1][j], arr[i-1][j]);
                }
                // Add the right element
                g.addEdge(nodes[i][j], nodes[i][j+1], arr[i][j+1]);
                // Add the lower element
                if(i != MATRIX_SIZE - 1) {
                    g.addEdge(nodes[i][j], nodes[i+1][j], arr[i+1][j]);
                }
                // Add the left element
                if(j != 0) {
                    g.addEdge(nodes[i][j], nodes[i][j-1], arr[i][j-1]);
                }
            }
        }
        
        // Special case of start node, points to first node and costs
        // the first node's cost
        Node startNode = new Node(-1,-1);
        g.addNode(startNode);
        g.addEdge(startNode, nodes[0][0], arr[0][0]);

        // Now calculate the cost for the start node and pick out the cost to the
        // bottom right node
        Map<Node, Double> results = Dijkstra.shortestPaths(g,startNode);
        return results.get(nodes[MATRIX_SIZE-1][MATRIX_SIZE-1]).intValue();
        /*            
        System.out.println(
            String.format("From left node %d (%d,%d) to right node %d (%d,%d) got cost %d", 
                startNodeIndex, startNode.i, startNode.j,
                endNodeIndex, endNode.i, endNode.j,
                min_cost
            )
        );
        */
    }

    /** Pass in the matrix file and size */
    public static void main(String... args) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(new File(args[0])));
      
        int MATRIX_SIZE = Integer.valueOf(args[1]);
        
        int[][] arr = new int[MATRIX_SIZE][MATRIX_SIZE];
   
        String line;
        int i = 0;
        while((line = br.readLine()) != null) {
            int j = 0;
            String[] tokens = line.split(",");
            for(String s : tokens) {
                arr[i][j++] = Integer.valueOf(s);
            }
            i++;
        }
        
        int minCost = calculateMinCost(arr);
        
        System.out.println(String.format("The minimum cost for %s is %d", args[0], minCost));
    }
}