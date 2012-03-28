component displayname="ContactsCollection" output="false" initmethod="init" extends="Utility"
{

/**
*@hint constructor
*/

	public ContactsCollection function init() {
		return this;
	}

/**
*@hint Returns an array containing contacts found by searching for an email address
*@emailAddress Email address to search for
*/

	public array function searchByEmail(required string emailAddress) {
		local.returnArray = arrayNew(1);
		local.searchXml = xmlParse(CTCTRequest('get', application.apiPath & '/contacts?email=' & arguments.emailAddress));
		if (isdefined('local.searchXml.feed.entry')) {
			for(i=1; i LTE arrayLen(local.searchXml.feed.entry); i=i+1) {
				local.contact = {
					id = local.searchXml.feed.entry[i].id.xmlText,
					contactLink = application.path & local.searchXml.feed.entry[i].link.xmlAttributes.href,
					updated = local.searchXml.feed.entry[i].updated.xmlText,
					status = local.searchXml.feed.entry[i].content.Contact.status.xmlText,
					emailAddress = local.searchXml.feed.entry[i].content.Contact.emailAddress.xmlText,
					emailType = local.searchXml.feed.entry[i].content.Contact.emailtype.xmlText,
					fullname = local.searchXml.feed.entry[i].content.Contact.name.xmlText,
					optInSource = local.searchXml.feed.entry[i].content.Contact.optInSource.xmlText};
				local.foundContact = new Contact(argumentCollection = local.contact);
				arrayAppend(local.returnArray, local.foundContact);
			}					
		}
		return local.returnArray;
	}
	
	/**
	*@hint Returns an string of the contactId if the contact is found, else returns 0
	*@emailAddress string Email address to search for
	*/
	public string function getContactId(required string contactEmail)
	{
		local.url = 'https://api.constantcontact.com/ws/customers/#application.ccUsername#/contacts?email=#arguments.contactEmail#';
		local.subscriberXml = xmlParse(CTCTRequest('get', local.url));
		if (structKeyExists(local.subscriberxml.feed, "entry"))
		{
			return local.subscriberxml.feed.entry.id.xmltext;
		} else {
			return 0;
		}
	}


/**
*@hint Determine if a contact already exists in Constant Contact - Returns true if a contact exists else false
*@emailAddress Email address to search for
*/
	
	public boolean function doesContactExist(required string emailAddress) {
		local.httpResponse = xmlParse(CTCTRequest('get', application.apiPath & '/contacts?email=' & arguments.emailAddress));
		if (isdefined('local.httpResponse.feed.entry')) {
			return true;
		} else {
			return false;
		}	
	}
	
/**
*@hint Returns array of the 50 Contacts, and a link to next page if one exists
*@page Optional URL if performing this function on a page other than the first 
*/			
	
	public array function getContacts(string page='#application.apiPath#/contacts') {
		local.retrieveContacts = CTCTRequest('get',arguments.page);
		local.contactsXml = xmlParse(local.retrieveContacts);
		local.nextAddress = "";
		local.linkArray = arrayNew(1);
		local.contactArray = arrayNew(1);
		local.fullContactArray = arrayNew(1);
		for(i=1; i LTE arrayLen(local.contactsXml.feed.entry); i=i+1) {
			local.contact = {
				id = local.contactsXml.feed.entry[i].id.xmlText,
				contactLink = application.path & local.contactsXml.feed.entry[i].link.XmlAttributes.href,
				name = local.contactsXml.feed.entry[i].Content.contact.Name.XmlText,
				emailaddress = local.contactsXml.feed.entry[i].Content.contact.EmailAddress.XmlText,
				status = local.contactsXml.feed.entry[i].Content.contact.Status.XmlText,
				updated = local.contactsXml.feed.entry[i].Updated.XmlText};
			local.newContact = new Contact(argumentCollection = local.contact);
			arrayAppend(local.contactArray, local.newContact);
		}
		arrayAppend(local.fullContactArray, local.contactArray);
		local.nextLinkSearch = xmlSearch (local.contactsXml, "//*[@rel='next']");
		if (!arrayIsEmpty(local.nextLinkSearch)) {
			local.nextAddress = application.path & local.nextLinkSearch[1].xmlAttributes.href;
		}
		local.linkArray[1] = local.nextAddress;
		arrayAppend(local.fullContactArray, local.linkArray);
		return local.fullContactArray;
	}
	
/**
*@hint Returns a Contact containing all details that exist in Constant Contact
*@contact Contact to retrieve details for 
*/		
	
	public Contact function getContactDetails(required Contact contact) {
		local.subscriberXml = xmlParse(CTCTRequest('get',arguments.contact.getContactLink()));
		local.contactStruct = createContactStruct(local.subscriberXml);
		local.newContact = new Contact(argumentCollection = local.contactStruct);
		return local.newContact;
	}
	
/**
*@hint Adds a Contact to Constant Contact using properties of the Contact object
*@contact Contact to add to Constant Contact
*/
	
	public Contact function addContact(required Contact contact) {
		local.newContactXml = createContactXml(arguments.contact);
		local.responseXml = CTCTRequest('post', '#application.apiPath#/contacts', local.newContactXml);
		local.contactStruct = createContactStruct(local.responseXml);
		arguments.contact.setId(local.contactStruct.id);
		arguments.contact.setContactLink(local.contactStruct.contactLink);
		local.newContact = new Contact(argumentCollection = local.contactStruct);
		return local.newContact;
	}
	
/**
*@hint Updates a Contact to Constant Contact using properties of the Contact object
*@contact Contact to update in Constant Contact
*/	
	
	public string function updateContact(required Contact contact) {
		local.contactXml = createContactXml(arguments.contact);
		local.httpResponse = CTCTRequest('put', '#arguments.contact.getContactLink()#', local.contactXml);
		return local.httpResponse;	
	}
	
/**
*@hint Removes a contact from all contact Lists and sets their status to 'Removed'
*@contact Contact to removed in Constant Contact
*/	
	
	public void function removeContact(required Contact contact) {
		local.contactXml = createContactXml(arguments.contact);
		arrayClear(local.contactXml.entry.content.Contact.ContactLists.XmlChildren);
		arguments.contact.setStatus('Removed');
		arguments.contact.setContactLists(#arrayNew(1)#);
		local.httpResponse = CTCTRequest('put', '#arguments.contact.getContactLink()#', local.contactXml);
	}	
	
/**
*@hint Deletes a contact from Constant Contact and sets their status to 'Do Not Mail'
*@contact Contact to removed in Constant Contact
*/		
	
	public void function deleteContact(required Contact contact) {
		local.contactXml = createContactXml(arguments.contact);
		arguments.contact.setStatus('Removed');
		local.httpResponse = CTCTRequest('delete', '#arguments.contact.getContactLink()#');
	}
	
/**
*@hint Retrieves an array of a specific event report for a Contact
*@contact Contact to retrieve event report for
*@eventType Type of event report to retrieve: Valid options are: SENDS, OPENS, CLICKS, BOUNCES, FORWARDS, and OPTOUTS
*/		
	
	public array function getEvents(required Contact contact, required string eventType) {
		local.allEvents = arrayNew(1);
		local.contactLink = arguments.contact.getContactLink();
		if(arguments.eventType EQ 'sends') {local.event = 'SentEvent';}
		if(arguments.eventType EQ 'opens') {local.event = 'OpenEvent';}
		if(arguments.eventType EQ 'clicks') {local.event = 'ClickEvent';}
		if(arguments.eventType EQ 'bounces') {local.event = 'BounceEvent';}
		if(arguments.eventType EQ 'forwards') {local.event = 'ForwardEvent';}
		if(arguments.eventType EQ 'optouts') {local.event = 'OptoutEvent';}
		local.eventXml = xmlParse(CTCTRequest('get', '#local.contactLink#/events/#arguments.eventType#'));
		local.eventIdSearch = "//*[local-name()='#local.event#' and namespace-uri()='http://ws.constantcontact.com/ns/1.0/']";
		local.result = xmlSearch(local.eventXml, local.eventIdSearch);
		for(i=1; i LTE arrayLen(local.result); i=i+1) {
			local.event = {
				id = local.result[i].xmlAttributes.id,
				campaignLink = application.path & local.result[i].campaign.link.xmlAttributes.href,
				name = local.result[i].campaign.name.xmlText,
				eventTime = local.result[i].eventtime.xmlText};
			arrayAppend(local.allEvents, local.event);
		}
		return local.allEvents;
	}
	
/**
*@hint Creates a structure to be used in creating a Contact object
*@xml XML to be converted to a structure
*/		
	
	public struct function createContactStruct(required xml contactXml) {
		local.subscriberXml = xmlParse(arguments.contactXml);
		local.contactLists = arrayNew(1);
		local.searchLink = xmlSearch (local.subscriberXml, "//*[@rel='edit']");
		local.tempStruct = local.subscriberXml.entry.content.Contact;
		local.subscriberDetails = {
			contactLink = application.path & local.searchlink[1].xmlAttributes.href,
			id = local.subscriberxml.entry.id.xmlText,
			emailAddress = local.tempStruct.emailAddress.xmlText,
			emailType = local.tempStruct.emailType.xmlText,
			status = local.tempStruct.status.xmlText,	
			firstName = local.tempStruct.firstName.xmlText,
			lastName = local.tempStruct.lastName.xmlText,
			fullName = local.tempStruct.name.xmlText,
			jobTitle = local.tempStruct.jobTitle.xmlText,
			companyName= local.tempStruct.companyName.xmlText,
			homePhone = local.tempStruct.homePhone.xmlText,
			workPhone = local.tempStruct.workPhone.xmlText,
			addr1 = local.tempStruct.addr1.xmlText,
			addr2 = local.tempStruct.addr2.xmlText,
			addr3 = local.tempStruct.addr3.xmlText,
			city = local.tempStruct.city.xmlText,
			stateCode = local.tempStruct.stateCode.xmlText,
			stateName = local.tempStruct.stateName.xmlText,
			countryCode = local.tempStruct.countryCode.xmlText,
			postalCode = local.tempStruct.postalCode.xmlText,
			subPostalCode = local.tempStruct.subPostalCode.xmlText,		
			customField1 = local.tempStruct.customField1.xmlText,
			customField2 = local.tempStruct.customField2.xmlText,
			customField3 = local.tempStruct.customField3.xmlText,
			customField4 = local.tempStruct.customField4.xmlText,
			customField5 = local.tempStruct.customField5.xmlText,
			customField6 = local.tempStruct.customField6.xmlText,
			customField7 = local.tempStruct.customField7.xmlText,
			customField8 = local.tempStruct.customField8.xmlText,
			customField9 = local.tempStruct.customField9.xmlText,
			customField10 = local.tempStruct.customField10.xmlText,
			customField11 = local.tempStruct.customField11.xmlText,
			customField12 = local.tempStruct.customField12.xmlText,
			customField13 = local.tempStruct.customField13.xmlText,
			customField14 = local.tempStruct.customField14.xmlText,
			customField15 = local.tempStruct.customField15.xmlText,
			note = local.tempStruct.note.xmlText};
		if(isdefined('local.tempStruct.ContactLists')) {
			for(i=1; i LTE arrayLen(local.tempStruct.ContactLists.ContactList); i=i+1) {
				local.contactLists[i] = local.tempStruct.ContactLists.ContactList[i].xmlAttributes.id;
			}
		}
		local.subscriberDetails['contactLists'] = local.contactLists;
		return local.subscriberDetails;
	}
	
/**
*@hint Creates XML to be used for sending Contact information to Constant Contact 
*@contact Contact to have XML generated for
*/		
	
	public xml function createContactXml(required Contact contact) {
		local.contact = arguments.contact;
		savecontent variable="local.part1" {
			writeOutput('<entry xmlns="http://www.w3.org/2005/Atom">
				<title type="text"> </title>
				<updated>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</updated>
				<author></author>
			    <id>#local.contact.getId()#</id>
				<summary type="text">Contact</summary>
				<content type="application/vnd.ctct+xml">
					<Contact xmlns="http://ws.constantcontact.com/ns/1.0/">
						<EmailAddress>#local.contact.getEmailAddress()#</EmailAddress>
						<EmailType>#local.contact.getEmailType()#</EmailType>
						<FirstName>#local.contact.getFirstName()#</FirstName>						
						<MiddleName>#local.contact.getMiddleName()#</MiddleName>
						<LastName>#local.contact.getLastName()#</LastName>
						<JobTitle>#local.contact.getJobTitle()#</JobTitle>
						<CompanyName>#local.contact.getCompanyName()#</CompanyName>
						<WorkPhone>#local.contact.getWorkPhone()#</WorkPhone>
						<HomePhone>#local.contact.getHomePhone()#</HomePhone>
						<Addr1>#local.contact.getAddr1()#</Addr1>
						<Addr2>#local.contact.getAddr2()#</Addr2>
						<Addr3>#local.contact.getAddr3()#</Addr3>
						<City>#local.contact.getCity()#</City>
						<OptInSource>#local.contact.getOptInSource()#</OptInSource>
						<StateCode>#local.contact.getStateCode()#</StateCode>
						<StateName>#local.contact.getStateName()#</StateName>
						<CountryCode>#local.contact.getCountryCode()#</CountryCode>
						<PostalCode>#local.contact.getPostalCode()#</PostalCode>
						<SubPostalCode>#local.contact.getSubPostalCode()#</SubPostalCode>
						<CustomField1>#local.contact.getCustomField1()#</CustomField1>
						<CustomField2>#local.contact.getCustomField2()#</CustomField2>
						<CustomField3>#local.contact.getCustomField3()#</CustomField3>
						<CustomField4>#local.contact.getCustomField4()#</CustomField4>
						<CustomField5>#local.contact.getCustomField5()#</CustomField5>
						<CustomField6>#local.contact.getCustomField6()#</CustomField6>
						<CustomField7>#local.contact.getCustomField7()#</CustomField7>
						<CustomField8>#local.contact.getCustomField8()#</CustomField8>
						<CustomField9>#local.contact.getCustomField9()#</CustomField9>
						<CustomField10>#local.contact.getCustomField10()#</CustomField10>
						<CustomField11>#local.contact.getCustomField11()#</CustomField11>
						<CustomField12>#local.contact.getCustomField12()#</CustomField12>
						<CustomField13>#local.contact.getCustomField13()#</CustomField13>
						<CustomField14>#local.contact.getCustomField14()#</CustomField14>
						<CustomField15>#local.contact.getCustomField15()#</CustomField15>
						<Note>#local.contact.getNote()#</Note>
						<OptInSource>#local.contact.getOptInSource()#</OptInSource>
						<ContactLists>');
		};
		savecontent variable="local.part2" {
			for(i=1; i LTE arrayLen(local.contact.getContactLists()); i=i+1) {
				writeOutput('<ContactList id="#local.contact.getContactLists()[i]#"/>');
			}
		};
		savecontent variable="local.part3" {
			writeOutput('</ContactLists></Contact></content></entry>');
		};
		local.fullXml = xmlParse(local.part1 & local.part2 & local.part3);
		return local.fullXml;
	}
	
}
