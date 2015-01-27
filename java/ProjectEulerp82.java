import java.util.*;
import java.io.*;

/**
 * Graph and algorithm code from http://www.keithschwarz.com/interesting/
 */
public class ProjectEulerp82 {
    
    public static class Node {
        int i,j;
        public Node() {}
        public Node(int i_, int j_) { i = i_; j = j_; }
    }

    private static int calculateMinCost(int[][] arr) {
        int MATRIX_SIZE = arr.length;
        
        DirectedGraph<Node> g = new DirectedGraph<Node>();
        
        Node[] leftMostNodes = new Node[MATRIX_SIZE];
        Node[][] nodes = new Node[MATRIX_SIZE][MATRIX_SIZE];
        
        // Create all the nodes
        for(int i = 0; i < arr.length; i++) {
            leftMostNodes[i] = new Node(i,-1);
            g.addNode(leftMostNodes[i]);
            for(int j = 0; j < arr[i].length; j++) {
                nodes[i][j] = new Node(i,j);
                g.addNode(nodes[i][j]);
            }
        }
        
        for(int i = 0; i < MATRIX_SIZE; i++) {
            System.out.println(String.format("Adding nodes for row %d", i));
            for(int j = 0; j < MATRIX_SIZE - 1; j++) {
                // If we're on the left-most element, we're going to create
                // an initial node to the left of the array to hold the cost of
                // starting at that element
                if(j == 0) {
                    g.addEdge(leftMostNodes[i], nodes[i][j], arr[i][j]);
                }
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
            }
        }
        
        int min_left_index = -1;
        int min_right_index = -1;
        int min_cost = Integer.MAX_VALUE;
        
        // Now calculate the cost for every left node and find the min amongst
        // all the right nodes
        for(int startNodeIndex = 0; startNodeIndex < MATRIX_SIZE; startNodeIndex++) {
            System.out.println(String.format("Calculating costs for row %d", startNodeIndex));
            
            Node startNode = leftMostNodes[startNodeIndex];
            Map<Node, Double> results = Dijkstra.shortestPaths(g,startNode);

            for(int endNodeIndex = 0; endNodeIndex < MATRIX_SIZE; endNodeIndex++) {
                
                Node endNode = nodes[endNodeIndex][MATRIX_SIZE-1];
                
                if(results.containsKey(endNode) &&results.get(endNode) < min_cost) {
                    
                    min_left_index = startNodeIndex;
                    min_right_index = endNodeIndex;
                    min_cost = results.get(nodes[endNodeIndex][MATRIX_SIZE-1]).intValue();
                    
                    System.out.println(
                        String.format("From left node %d (%d,%d) to right node %d (%d,%d) got cost %d", 
                            startNodeIndex, startNode.i, startNode.j,
                            endNodeIndex, endNode.i, endNode.j,
                            min_cost
                        )
                    );
                }
            }
        }
        
        return min_cost;
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