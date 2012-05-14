package aspects;

public aspect Polizist {
	/*
	void around(String u,String p) : 
		call(* Cracker.*(..)) && adviceexecution() && args(u,p) {
		System.out.println("Cracker aspect neutralized");
		//proceed(userName, "falsePassword");
		
	}
	*/

    pointcut myAdvice(): adviceexecution() && within(Cracker);

    before(): call(void *(..)) {
    	System.out.println("Hello");
	  // do something
    }
}
