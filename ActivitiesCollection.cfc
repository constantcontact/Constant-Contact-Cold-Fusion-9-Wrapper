component displayname="ActivitiesCollection" output="false" initmethod="init" extends="Utility"
{
/**
*@hint constructor 
*/
	public ActivitiesCollection function init() {
		return this;
	}

/**
*@hint Returns array of the 50 most recent activities, and a link to next page if one exists
*@page Optional URL if performing this function on a page other than the first 
*/	
	
	public array function getActivites(string page="#application.apiPath#/activities") {
		local.activitiesArray = arrayNew(1);
		local.nextAddress = "";
		local.fullArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.activityXml = xmlParse(CTCTRequest('get',arguments.page));
		for(i=1; i LTE arrayLen(local.activityXml.feed.entry); i=i+1) {
			local.activity = createActivityStruct(local.activityxml.feed.entry[i]);
			local.newActivity = new Activity(argumentCollection = local.activity);
			arrayAppend(local.activitiesArray, local.newActivity);
		}
		arrayAppend(local.fullArray, local.activitiesArray);
		local.nextLinkSearch = xmlSearch(local.activityXml, "//*[@rel='next']");
		if(!arrayIsEmpty(local.nextLinkSearch)) {
			local.nextAddress = application.apiPath & local.nextLinkSearch[1].XmlAttributes.href;
		}
		local.linkArray[1] = local.nextAddress;
		arrayAppend(local.fullArray, local.linkArray);
		return local.fullArray; 
	}
	
/**
*@hint Returns an activity object containing all details in Constant Contact
*@activity Activity object to retrieve details on 
*/		
	
	public Activity function getActivityDetails(required Activity activity) {
		local.activityXml = CTCTRequest('get', arguments.activity.getActivityLink());
		local.activityStruct = createActivityStruct(local.activityXml);
		local.activity = new Activity(argumentCollection = local.activityStruct);
		return local.activity;
	}

/**
*@hint Creates an export activity 
*@listId List to export Contacts from -  System defined lists, such as 'do-not-mail' are supported.
*@columns Array of column data to include. - Valid columns available at http://developer.constantcontact.com/doc/activities
*@fileType Valid options are CSV and TXT - CSV is default
*@exportOptDate - boolean of whether to export the optIn date of the contacts
*@exportOptSource - boolean of whether to export the optInSource of the contacts
*@exportListName - boolean of whether to export the ListName 
*@soryBy - in what order should the txt/csv file be - Valid options are EMAIL_ADDRESS and DATE_DESC. EMAIL is default.
*/	
	
	public Activity function bulkExportContacts(
	required string listId,
	required array columns,
	string fileType = "CSV",
	boolean exportOptDate = "true",
	boolean exportOptSource = "true",
	boolean exportListName = "true",
	string sortBy = "EMAIL_ADDRESS"
	) {
		local.httpResponse = exportContactsPost(argumentCollection = arguments);
		local.activityStruct = createActivityStruct(local.httpResponse);
		local.activity = new Activity(argumentCollection = local.activityStruct);
		return local.activity;
	}
	
/**
*@hint Performs a URLencoded POST to upload a csv of contacts to Constant Contact
*@activityType Type of activity to perform - valid options: ADD_CONTACTS, SV_ADD, ADD_CONTACT_DETAIL, REMOVE_CONTACTS_FROM_LISTS
*@lists Array of lists for the activity to be performed on
*@fileconents Contents to be uploaded
*/		
	
	public Activity function bulkUrlEncoded(required string uploadString) {
		local.httpResponse = urlEncodedPost(uploadString);
		local.activityStruct = createActivityStruct(local.httpResponse);
		local.activity = new Activity(argumentCollection = local.activityStruct);
		return local.activity;
	}

/**
*@hint Performs a URLencoded POST to upload a csv of contacts to Constant Contact
*@activityType Type of activity to perform - valid options: ADD_CONTACTS, SV_ADD, ADD_CONTACT_DETAIL, REMOVE_CONTACTS_FROM_LISTS
*@lists Array of lists for the activity to be performed on
*@fileLocation Location of csv file to upload 
*/
	
	public Activity function bulkMultiPart(required string activityType, required array lists, string fileContents) {
		local.bulkUpload = {
			activityType = arguments.activityType,
			lists = arguments.lists,
			dataFile = arguments.fileContents};
		local.httpResponse = multiPartPost(argumentCollection = local.bulkUpload);
		local.activityStruct = createActivityStruct(local.httpResponse);
		local.createdActivity = new Activity(argumentCollection = local.activityStruct);
		return local.createdActivity;
	}
	
	public Activity function clearContactsFromLists(required array lists) {
		local.clearRequest = {
			activityType = 'CLEAR_CONTACTS_FROM_LISTS',
			lists = arguments.lists};
		local.httpResponse = multiPartPost(argumentCollection = local.clearRequest);
		local.activityStruct = createActivityStruct(local.httpResponse);
		local.createdActivity = new Activity(argumentCollection = local.activityStruct);
		return local.createdActivity;
	}

/**
*@hint Creates a structure representing an activity from XML returned by CTCT
*@activityXml XML to be converted to a Structure
*/
	
	private struct function createActivityStruct(required xml activityXml) {
		local.activityXml = xmlParse(arguments.activityXml);
		local.activity = {
			activityName = local.activityXml.entry.title.xmlText,
			activityId = local.activityXml.entry.id.xmlText,
			activityLink = '#application.path#/#local.activityXml.entry.link.xmlAttributes.href#',
			updated = local.activityxml.entry.updated.xmlText,
			type = local.activityXml.entry.content.activity.type.xmlText,
			status = local.activityXml.entry.content.activity.status.xmlText,
			transactionCount = local.activityXml.entry.content.activity.transactionCount.xmlText,
			errors = local.activityXml.entry.content.activity.errors.xmlText};
			insertTime = local.activityXml.entry.content.activity.insertTime.xmlText;
			if(isdefined('local.activityXml.entry.content.activity.runStartTime')) {
				local.activity.runStartTime = local.activityXml.entry.content.activity.runStartTime.xmlText;
				local.activity.runFinishTime = local.activityXml.entry.content.activity.runFinishTime.xmlText;
			}
			if(isdefined('local.activityXml.entry.content.activity.FileName')){
				local.activity.fileName = local.activityXml.entry.content.activity.fileName.xmlText;
			} 
		return local.activity;
	}
}