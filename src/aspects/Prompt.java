package aspects;
import java.io.*;

public class Prompt {

   public static String prompt (String s) {

      //  prompt the user to enter their name
      System.out.print(s);

      //  open up standard input
      BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
      String ret = "";
      try {
    	  ret = br.readLine();    	  
      }catch (IOException ioe) {
    	  
      }
      
      return ret;      
   }

}  