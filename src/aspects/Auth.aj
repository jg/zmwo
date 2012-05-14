package aspects;

import java.awt.List;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import telecom.Call;
import telecom.Customer;
import aspects.Prompt;

/*
Telecom kontynuuje współpracę z Aspect Advanced. Firma telekomunikacyjna pragnie wprowadzić nową
funkcjonalność do swojego systemu monitorowania. Ze względu na próby włamania, konieczna jest
autentykacja klienta przy wykonywaniu połączeń. Nowa usługa systemu może być zaimplementowana jako
aspekt. Właśnie otrzymałeś nowe zadanie.
Zaimplementuj aspekt, który:
- pobiera hasło od użytkownika
- weryfikuje hasło w momencie wykonywania przez użytkownika połączenia wychodzącego.
Informacje o użytkownikach i hasłach mogą być przechowywane w zwykłym pliku tekstowym lub np. w
serializowanym słowniku.

 
 */
public aspect Auth {
	HashMap<String,String> passwords;
	public static final String PASSWORD_FILE="passwords.txt";
	
	// public Call call(Customer receiver) {
	pointcut placeCall(Customer callee) : call(* Customer.call(..)) && target(callee);
	
	pointcut initUser() : call(Customer.new(..));
	
	Auth() {
		passwords = new HashMap<String,String>();
	}
	
	// pobiera hasło od użytkownika
	after() returning(Customer c): initUser() {
		String user = c.getName();
		String pass = Prompt.prompt("Podaj hasło dla użytkownika " + user + " : ");
		addUserAuthData(user, pass);
		
		
		//+ callee.toString());
	}
	
	// weryfikuje hasło w momencie wykonywania przez użytkownika połączenia wychodzącego.
	before(Customer callee) : placeCall(callee) {		
		loadPasswordDictionary();
		String userString = callee.toString();
		String userName = userString.substring(0,userString.indexOf("("));
		
		//String givenPass = "testtest";
		String givenPass = Prompt.prompt("Podaj hasło dla użytkownika " + userName + " : ");
		System.out.println("Podano: " + givenPass);
		if (authenticatedP(userName, givenPass)) {
			System.out.println("Weryfikacja hasła powiodła się");
		}else {			
			throw new RuntimeException("Złe hasło");
		}
		
		
		//System.out.println("call from " + callee.toString());
		//System.out.println("Method Signature: " + thisJoinPoint.getSignature().toLongString());
		// load file
	}
	
	// Command: loads a data from PASSWORD_FILE into passwords hashmap(User->Password) 
	public void loadPasswordDictionary() {						
		try {
			String[] array = readFileAsString(PASSWORD_FILE).split("\n");

			for(int i = 0; i < array.length; i++) {
				String[] p = array[i].split(":");	
				passwords.put(p[0],p[1]);							
			}			
			
		} catch (IOException e) {
			System.out.println("Could'nt open " + PASSWORD_FILE);
			e.printStackTrace();
		}
	}
	
	public void addUserAuthData(String username, String password) {
		PrintWriter pw;
		
		try {
			pw = new PrintWriter(new FileWriter(PASSWORD_FILE, true));
			pw.println(username + ":" + password);
			System.out.println("Dodano (" + username + ", " + password + ") do " + PASSWORD_FILE);
			pw.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block			
			e.printStackTrace();
		}
		
	}
	
	// Query: verify user name/pass authenticity
	public boolean authenticatedP(String username, String password) {
		
		/*
		Set<String> sortedKeys = new TreeSet<String>();
		sortedKeys.addAll(passwords.keySet());
		System.out.println("-------------------------\n");
		for(String key: sortedKeys){
		    System.out.println(key  + ":" + passwords.get(key));
		}
		System.out.println("-------------------------\n");
		*/
		
		String pw;
		if ((pw = passwords.get(username)) != null)
			return pw.equals(password);
		else
			return false;		
	}
	
	public String getPasswordFromConsole(String username) {        
		try {
			InputStreamReader isr = new InputStreamReader(System.in);
	        BufferedReader br = new BufferedReader(isr);
	        System.out.println("Password for user " + username + " : ");
	        String s;
			s = br.readLine();
			return s;
		} catch (IOException e) {
			// TODO Auto-generated catch block			
			e.printStackTrace();
		}
		return "";        
	}
		
	private static String readFileAsString(String filePath) throws java.io.IOException{
	    byte[] buffer = new byte[(int) new File(filePath).length()];
	    FileInputStream f = new FileInputStream(filePath);
	    f.read(buffer);
	    return new String(buffer);
	}
	
}

