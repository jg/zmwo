package aspects;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.HashMap;

import telecom.Call;
import telecom.Customer;

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
	
	pointcut initUser(Object callee) : call(Customer.new(..)) && this(callee);
	
	// pobiera hasło od użytkownika
	after(Object callee) returning: initUser(callee) {
		System.out.println(callee.toString());
	}
	
	// weryfikuje hasło w momencie wykonywania przez użytkownika połączenia wychodzącego.
	before(Customer callee) : placeCall(callee) {
		// loadPasswordDictionary();
		//System.out.println("call from " + callee.toString());
		//System.out.println("Method Signature: " + thisJoinPoint.getSignature().toLongString());
		// load file
	}
	
	// Command: loads a data from PASSWORD_FILE into passwords hashmap(User->Password) 
	public void loadPasswordDictionary() {		
		if (passwords != null) return;
		
		try {
			String[] array = readFileAsString(PASSWORD_FILE).split(":");
			for(int i = 0; i < array.length; i=i+2) passwords.put(array[i], array[i+1]);							
		} catch (IOException e) {
			System.out.println("Could'nt open " + PASSWORD_FILE);
			e.printStackTrace();
		}
	}
	
	public void addUserAuthData(String username, String password) {
		PrintWriter pw;
		
		try {
			pw = new PrintWriter(new FileWriter(PASSWORD_FILE, true));
			pw.printf("%s:%s\n", username, password);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	// Query: verify user name/pass authenticity
	public boolean authenticate(String username, String password) {
		return (password != null) && (passwords.get(username) == password);
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

