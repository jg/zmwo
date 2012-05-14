package aspects;

import aspects.Timer;
import java.io.IOException;

/*
Zadanie 2:
	Dyrektor Telecom jest bardzo zadowolony z Twojej dotychczasowej pracy. Zleca Aspect Advanced
	profilowanie kodu w celu optymalizacji. Samej analizy kodu i konkretnych poprawek dokona odpowiedni
	zespół. Do analizy potrzeba jednak danych.
	Zbuduj aspekt śledzący, który dla każdego wywołania metody zapisuje do pliku dziennika:
	• klasę obiektu, na rzecz którego została wykonana metoda
	• nazwy, typy i wartości argumentów metody
	• wynik zwracany przez metodę
	• czas wykonania metody podany w milisekundach
	Punkty złączeń mają wystąpić tylko w oryginalnym kodzie aplikacji, z pominięciem rozszerzeń aspektowych.
	Do pomiaru czasu wykonania metod można zastosować przykładową klasę Timer z pakietu aspects.
*/


public aspect Tracker implements IAspect {

	pointcut methodCall(Object caller, Object callee) : call(* *.*(..)) && this(caller) && target(callee) && !within(Tracker);
	
	Object around(Object caller, Object callee) : methodCall(caller, callee) && !within(MyFileWriter) {
		Timer timer = new Timer();
		
		
		timer.start();
		Object result = proceed(caller, callee);
		timer.stop();
		Long time = timer.getTime();
		
		
		MyFileWriter out;
		try {
			out = new MyFileWriter("log.txt", true);				 			
							
			out.println("Method Signature: " + thisJoinPoint.getSignature().toLongString());		
			out.println("Arguments: " + thisJoinPoint.getArgs().toString());
			out.println("Caller class: " + caller.getClass());		
			out.println("Callee class: " + callee.getClass());
			if (result != null)
				out.println("Result: " + result.toString());
			out.println("Elapsed Time: " + time.toString());
			
			out.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println("Couldn't open log file");
			e.printStackTrace();
		}
		return result;
		
	}
}
