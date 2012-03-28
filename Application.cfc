component displayname="Application" 
{
	
	public void function onRequestStart() {
	
		application.ccUsername = "username"; 							// Username 
		application.ccPassword = "password";							// Password 
		application.apiKey = "apikey";									// API Key 
		
		application.optInSource = "ACTION_BY_CUSTOMER"; 
		/*
		optInSource - How are these contacts being added. 
		ACTION_BY_CUSTOMER - Used for internal applications. Contact did not take the action to add themself to your list.
			This will not generate a 'Welcome Email'. 
		ACTION_BY_CONTACT - Used for sign up boxes where the customer is directly subscribing to your newsletter. 
			This will send a 'Welcome Email' when the user subscribes.
		*/
		
		/* set to true to use errorMessaging function in Utility.cfc to provide http error messaging */
		application.debug = true; 
									 
		application.path = "https://api.constantcontact.com";
		application.apiPath = "#application.path#/ws/customers/#APPLICATION.ccUsername#";
		application.doNotInclude = "Active,Do Not Mail,Removed";
	
	}
/*	
	public void function onError(required exception, required string eventName) {
		new Utility().errorMsg('#Arguments.Exception.rootcause.message#');
	}
*/
}