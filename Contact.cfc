component displayname="Contact" output="false" initmethod="init" accessors="true"
{
	property string emailAddress;
	property string id;
	property string status;
	property string contactLink;
	property string emailType;
	property string firstName;
	property string middleName;
	property string lastName;
	property string fullName;
	property string jobTitle;
	property string companyName;
	property string workPhone;
	property string homePhone;
	property string addr1;
	property string addr2;
	property string addr3;
	property string city;
	property string stateCode;
	property string stateName;
	property string countryCode;
	property string postalCode;
	property string subPostalCode;
	property string note;
	property string optInSource;
	property string customField1;
	property string customField2;
	property string customField3;
	property string customField4;
	property string customField5;
	property string customField6;
	property string customField7;
	property string customField8;
	property string customField9;
	property string customField10;
	property string customField11;
	property string customField12;
	property string customField13;
	property string customField14;
	property string customField15;
	property array contactLists;
	
	public Contact function init(
	required string emailAddress,
	string id = 'data:,none',
	string status = '',
	string contactLink = '',
	string emailType = '',
	string firstName = '',
	string middleName = '',
	string lastName = '',
	string fullName = '',
	string jobTitle = '',
	string companyName = '',
	string workPhone = '',
	string homePhone = '',
	string addr1 = '',
	string addr2 = '',
	string addr3 = '',
	string city = '',
	string stateCode = '',
	string stateName = '',
	string countryCode = '',
	string postalCode = '',
	string subPostalCode = '',
	string note = '',
	string optInSource = '#application.optInSource#',
	string customField1 = '',
	string customField2 = '',
	string customField3 = '',
	string customField4 = '',
	string customField5 = '',
	string customField6 = '',
	string customField7 = '',
	string customField8 = '',
	string customField9 = '',
	string customField10 = '',
	string customField11 = '',
	string customField12 = '',
	string customField13 = '',
	string customField14 = '',
	string customField15 = '',
	array ContactLists = '#arrayNew(1)#') {
		
		setEmailAddress(arguments.emailAddress);
		setId(arguments.id);
		setStatus(arguments.status);
		setEmailType(arguments.emailType);
		setContactLink(arguments.contactLink);
		setFirstName(arguments.firstName);
		setMiddleName(arguments.middleName);
		setLastName(arguments.lastName);
		setFulLName(arguments.fullName);
		setJobTitle(arguments.jobTitle);
		setCompanyName(arguments.companyName);
		setWorkPhone(arguments.workPhone);
		setHomePhone(arguments.homePhone);
		setAddr1(arguments.addr1);
		setAddr2(arguments.addr2);
		setAddr3(arguments.addr3);
		setCity(arguments.city);
		setStateCode(arguments.stateCode);
		setStateName(arguments.stateName);
		setCountryCode(arguments.countryCode);
		setPostalCode(arguments.postalCode);
		setSubPostalCode(arguments.subPostalCode);
		setNote(arguments.note);
		setOptInSource(arguments.optInSource);
		setCustomField1(arguments.customField1);
		setCustomField2(arguments.customField2);
		setCustomField3(arguments.customField3);
		setCustomField4(arguments.customField4);
		setCustomField5(arguments.customField5);
		setCustomField6(arguments.customField6);
		setCustomField7(arguments.customField7);
		setCustomField8(arguments.customField8);
		setCustomField9(arguments.customField9);
		setCustomField10(arguments.customField10);
		setCustomField11(arguments.customField11);
		setCustomField12(arguments.customField12);
		setCustomField13(arguments.customField13);
		setCustomField14(arguments.customField14);
		setCustomField15(arguments.customField15);
		setContactLists(arguments.contactLists);
		
		return this;
	}

} 