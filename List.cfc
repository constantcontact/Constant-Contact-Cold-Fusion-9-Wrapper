component displayname="List" output="false" initmethod="init" accessors="true"
{
	property string listName;
	property string id;
	property string listLink;
	property string updated;
	property boolean optInDefault;
	property boolean displayOnSignup;
	property string sortOrder;
	property string contactCount;
	
	public List function init(
	required string listName,
	string id = 'data:,none',
	string listLink = '',
	string updated = '',
	boolean optInDefault = false,
	boolean displayOnSignup = false,
	string sortOrder = '99',
	string contactCount = '') {
		
		setListName(arguments.listName);
		setId(arguments.id);
		setListLink(arguments.listLink);
		setUpdated(arguments.updated);
		setOptInDefault(arguments.optInDefault);
		setDisplayOnSignup(arguments.displayOnSignup);
		setSortOrder(arguments.sortOrder);
		setContactCount(arguments.contactCount);
		
		return this;
	
	}

}