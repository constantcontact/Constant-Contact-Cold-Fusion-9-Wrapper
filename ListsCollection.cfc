component displayname="ListsCollection" output="false" initmethod="init" extends="Utility" 
{
	public ListsCollection function init() {
		return this;
	}
/**
* @hint Returns 50 list members and a link to the next page if it exists
* @list List to get members from. Accepts id number (ie:12) or listLink property from a List
*/
	public array function getListMembers(required List list) {
		local.memberArray = arrayNew(1);
		local.fullMembersArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.nextAddress = "";
		local.contactsXml = xmlParse(CTCTRequest('get', '#arguments.list.getListLink()#/members'));
		if(isdefined('local.contactsXml.feed.entry')) {
			for(i=1; i LTE arrayLen(local.contactsXml.feed.entry); i=i+1) {
				local.contact = {
					// contactLink is /lists/1/members/31571 - which returns a 404
					contactLink = application.path & local.contactsXml.feed.entry[i].link.xmlattributes.href,
					contactId = local.contactsXml.feed.entry[i].id.xmltext,
					updated = local.contactsXml.feed.entry[i].updated.xmltext,
					emailAddress = local.contactsXml.feed.entry[i].content.contactlistmember.emailaddress.xmlText				
					};
				local.listMember = new Contact(argumentCollection=local.contact);
				arrayAppend(local.memberArray, local.listMember);
			}
			arrayAppend(local.fullMembersArray, local.memberArray);
			local.nextLinkSearch = xmlSearch (local.contactsXml, "//*[@rel='next']");
			if (!arrayIsEmpty(local.nextLinkSearch)) {
				local.nextAddress = application.path & local.nextLinkSearch[1].xmlAttributes.href;
			}
			local.linkArray[1] = local.nextAddress;
			arrayAppend(local.fullMembersArray, local.linkArray);
		}
		return local.fullMembersArray;
	}
	
/**
* @hint Returns list of 50 lists and link to the next page if it exists
* @page default to the lists collection, can also supply a 'next url' for pagination
*/
	public array function getLists(string page = application.apiPath & '/lists') {
		local.listsXml = xmlParse(CTCTRequest('get', arguments.page));
		local.nextAddress = "";
		local.listArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.getListsArray = arrayNew(1);	
		for(i=1; i LTE arrayLen(local.listsxml.feed.entry); i=i+1) {
			local.list = {
				listLink = application.path & local.listsXml.feed.entry[i].link.xmlattributes.href,
				id = local.listsxml.feed.entry[i].id.xmlText,
				listName = local.listsXml.feed.entry[i].content.contactlist.name.xmltext,
				updated = local.listsxml.feed.entry[i].updated.xmltext
				};
				
			if (StructKeyExists(local.listsXml.feed.entry[i].content.contactlist, "OptInDefault"))
				local.list.OptInDefault = local.listsXml.feed.entry[i].content.contactlist.OptInDefault.xmlText;

			if (StructKeyExists(local.listsXml.feed.entry[i].content.contactlist, "DisplayOnSignup"))
				local.list.DisplayOnSignup = local.listsXml.feed.entry[i].content.contactlist.DisplayOnSignup.xmlText;

			if (StructKeyExists(local.listsXml.feed.entry[i].content.contactlist, "SortOrder"))
				local.list.SortOrder = local.listsXml.feed.entry[i].content.contactlist.SortOrder.xmlText;

			local.newList = new List(argumentCollection = local.list);
			arrayAppend(local.listArray, local.newList);
		}
		arrayAppend(local.getListsArray, local.listArray);
		local.nextSearchLink = xmlSearch(local.listsXml, "//*[@rel='next']");
			if(!arrayIsEmpty(local.nextSearchLink)) {
				local.nextAddress = application.path & local.nextLinkSearch[1].xmlAttributes.href;
			}
			local.linkArray[1] = local.nextAddress;
			arrayAppend(local.getListsArray, local.linkArray);	
		return local.getListsArray;		
	}
/**
* @hint Gets all details for a list - returns a List
* @contactList List to retrieve details for. Accepts id number (ie:12) or listLink property from a List
*/
	public List function getListDetails(required any contactList) {
		if(isValid("integer", arguments.contactList)) {
			local.address = application.apiPath & '/lists/' & arguments.contactList;
		} else {
			local.address = arguments.contactList.getListLink();
		}
		local.listXml = CTCTRequest('get', local.address);
		local.listStruct = createListStruct(local.listXml);
		local.newList = new List (argumentCollection = local.listStruct);
		return newList;
	}
	
/**
* @hint Updates a List in Constant Contact with its current properties
* @list List to update
*/
	public string function updateList(required List list) {
		local.listXml = createListXml(arguments.list);
		local.httpResponse = CTCTRequest('put', arguments.list.getListLink(), local.listXml);
		return local.httpResponse;		
	}
	
/**
* @hint Adds a List in Constant Contact with its current properties
* @list List to add to your account
*/
	public List function addList(required List list) {
		local.newList = createListXml(arguments.list);
		local.httpResponse = CTCTRequest('post', application.apiPath & '/lists', local.newList);
		local.newListStruct = createListStruct(local.httpResponse);
		local.newList = new List(argumentCollection = local.newListStruct);
		return local.newList;
	}
	
/**
* @hint Deletes a List in Constant Contact - not reversable
* @list List to delete
*/
	public void function deleteList(required List list) {
		local.deleteLink = arguments.list.getListLink();
		local.httpResponse = CTCTRequest('delete', local.deleteLink);
	}

	public Activity function removeListMembers(required List list) {
		local.clearLinkArray = arrayNew(1);
		local.clearLinkArray[1] = arguments.list.getListLink();
		local.clearActivity = createObject("component", "ActivitiesCollection").clearContactsFromLists(local.clearLinkArray);
		return local.clearActivity;
	}


/**
* @hint Creates xml structure from a List object for httpRequests
* @list List to be converted to XML
*/
	private xml function createListXml(required List list) {
		local.listObj = arguments.list;
		savecontent variable="local.listXml" {
			writeOutput('<entry xmlns="http://www.w3.org/2005/Atom">
				<id>#local.listObj.getId()#</id>
				<title />
				<author />
				<updated>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</updated>
				<content type="application/vnd.ctct+xml">
					<ContactList xmlns="http://ws.constantcontact.com/ns/1.0/">
						<OptInDefault>#local.listObj.GetOptInDefault()#</OptInDefault>
						<Name>#local.listObj.GetListName()#</Name>
						<SortOrder>#local.listObj.getSortOrder()#</SortOrder>
					</ContactList>
				</content>
			</entry>');
			}
		local.listXml = xmlParse(local.listXml);
		return local.listXml;
	}
	
/**
* @hint Creates a structure from XML to be used in creating a List object
* @xml xml returned from getting contact details
*/
	private struct function createListStruct(required xml listXml) {
		local.listXml = xmlParse(arguments.listXml);
		local.findLink = xmlSearch(local.listXml, "//*[@rel='edit']");
		local.linkStruct = {
			listLink = application.path & local.findLink[1].XmlAttributes.href,
			listName = local.listXml.entry.title.xmlText,
			id = local.listXml.entry.id.xmlText,
			updated = local.listXml.entry.updated.xmlText,
			optInDefault = local.listXml.entry.content.contactlist.optindefault.xmltext,
			sortOrder = local.listXml.entry.content.ContactList.sortOrder.XmlText,
			contactCount = local.listXml.entry.content.ContactList.contactCount.XmlText
			};
		return local.linkStruct;
	}
}
