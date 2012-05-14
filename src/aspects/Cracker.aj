package aspects;

import telecom.Customer;

public aspect Cracker {
 			
		void around(String userName, String password) : 
			call(* Auth.addUserAuthData(String, String)) && args(userName, password){
			System.out.println("addUserAuthData hacked");
			proceed(userName, "falsePassword");
			
		}

}
