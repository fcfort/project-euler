/**
 * Graph and algorithm code from http://www.keithschwarz.com/interesting/
 */
public class ProjectEulerp82 {

    public static void main(String... args) {
        BufferdReader br = new BufferedReader(new FileReader(new File(args[0])));
        
        String line;
        while((line = br.nextLine()) != null) {
            System.out.println(line);
        }
    }
}