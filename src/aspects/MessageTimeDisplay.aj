package aspects;

import java.io.PrintStream;
import java.util.Calendar;

/*
 * Aspekt wyswietlajacy w konsoli czas rozpoczecia i zakonczenia nadawania
 * wiadomosci na konsole.
 */
public aspect MessageTimeDisplay implements IAspect
{
	/* XXX Aspect fields----------------------------------------------- */

	// Pole przechowujace kalendarz sluzacy do uzyskiwania daty i godziny
	private Calendar cld;

	/* XXX Pointcut and advice ---------------------------------------- */

	// Przekroj przechwytujacy wywolania print i println dla PrintStream
	pointcut printcut(String s): call(* PrintStream.print*(..)) && args(s);
/*
	// Sposób pierwszy, zakomentowany bo drugi krótszy
	
	// Przed wyswietleniem wiadomosci podajemy czas jej nadejscia
	before(): printcut() && !within(MessageTimeDisplay)
	{
		cld = Calendar.getInstance();
		System.out.print(" TIME[" + cld.getTime() + "]: ");
	}

	// Po wyswietleniu wiadomosci podajemy czas po przetworzeniu
	after(): printcut() && !within(MessageTimeDisplay)
	{
		cld = Calendar.getInstance();
		System.out.println(" EOM [" + cld.getTime() + "]");
	}
*/	
	
	// Sposób drugi - użycie around
	/*
	void around(String s): printcut(s) && !within(MessageTimeDisplay){
		cld = Calendar.getInstance();
		System.out.print(" TIME[" + cld.getTime() + "]: ");
		proceed(s); 		
		System.out.println(" EOM [" + cld.getTime() + "]");
	}
	*/
	
	
	
	
}
