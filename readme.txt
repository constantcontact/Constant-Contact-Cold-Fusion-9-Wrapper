This file demonstrates how to use the CFC's in the CTCT_Wrapper Library.
Coldfusion version 9,0,0,251028 Developer Edition   
Java Version 1.6.0_14

For support please visit http://developer.constantcontact.com
To report a bug or suggest improvements, please email WebServices@constantcontact.com

***
All functions demonstrated are assuming that the ccUsername, ccPassword and 
apiKey application variables are set in Application.cfc, as well as the following in the file
running these examples.

<cfset Activities = new ActivitiesCollection()>
<cfset Campaigns = new CampaignsCollection()>
<cfset Contacts = new ContactsCollection()>
<cfset Library = new LibraryCollection()>
<cfset Lists = new ListsCollection()>
***
  
-----
ActivitiesCollection.cfc
------

	getActivities() 
	
		<cfset activitiesArray = Activities.getActivites()>
		
	getActivityDetails()
	
		<cfset activitiesArray = Activities.getActivites()>
		<cfset singleActivity = myActivities[1][1]>
		<cfset detailedActivity = Activities.getActivityDetails(singleActivity)>
		
	bulkExportContacts()
	
		<cfset listid = "#application.apiPath#/lists/1">
		<cfset columns[1] = 'FIRST NAME'>
		<cfset columns[2] = 'LAST NAME'>
		<cfset exportActivity = Activities.bulkExportContacts(listid, columns)>
		
	bulkUrlEncoded()
	
		<cfset uploadString = "activityType=SV_ADD&data=Email+Address%2CFirst+Name%2CLast+Name%0A
		wstest3%40example.com%2C+Fred%2C+Test%0A
		wstest4%40example.com%2C+Joan%2C+Test%0A
		wstest5%40example.com%2C+Ann%2C+Test
		&lists=http%3A%2F%2Fapi.constantcontact.com%2Fws%2Fcustomers%2Fjoesflowers%2Flists%2F6">

		<cfset bulkActivity = Activities.bulkUrlEncoded(uploadString)>
		
	bulkMultiPart()
		*note the getListLink() function on a List object will also produce the necessary links for the
		myLists array below*
		
		<cffile action="read" file="C:\Users\JohnDoe\Desktop\example.csv" variable="dataFile"/>
		<cfset myLists = arrayNew(1)>
		<cfset myLists[1] = '#application.apiPath#/lists/1'>
		<cfset myLists[2] = '#application.apiPath#/lists/2'>
		<cfset bulkActivity = Activities.bulkMultiPart('SV_ADD', myLists, dataFile)>
	
	clearContactsFromLists()
	
		<cfset myLists = arrayNew(1)>
		<cfset myLists[1] = '#application.apiPath#/lists/2'>
		<cfset myLists[2] = '#application.apiPath#/lists/3'>
		<cfset clearActivity = Activities.clearContactsFromLists(myLists)>	
		
		
-----
CampaignsCollection.cfc
------

	addCampaign()
	
		<cfset myNewEmail = new Campaign('My Title')>
		<cfset changeSubject = myNewEmail.setSubject('Check out my email')>
		<cfset addCampaign = Campaigns.addCampaign(myNewEmail)>

	updateCampaign()
	
		<cfset campaignsArray = Campaigns.getCampaigns()>
		<cfset specificCampaign = campaignsArray[1][1]>
		<cfset changeSubject = specificCampaign.setSubject('my new subject!')>
		<cfset updateCampaign = Campaigns.updateCampaign(specificCampaign)>
		
	deleteCampaign()
	
		<cfset campaignsArray = Campaigns.getCampaigns()>
		<cfset specificCampaign = campaignsArray[1][1]>
		<cfset deleteCampaign = Campaigns.deleteCampaign(specificCampaign)>
			
	getCampaigns()
		
		<cfset campaignsArray = Campaigns.getCampaigns()>

	getCampaignDetails()
		
		<cfset campaignsArray = Campaigns.getCampaigns()>
		<cfset specificCampaign = campaignsArray[1][1]>

----
ContactsCollection.cfc
----

	addContact()

		<cfset John = new Contact('JohnDoe@example.com')>
		<cfset myLists[1] = '#application.apiPath#/lists/6'>
		<cfset myLists[2] = '#application.apiPath#/lists/7'>
		<cfset addLists = John.setContactLists(myLists)>
		<cfset addContact = Contacts.addContact(John)>
		

	doesContactExist()
	
		<cfset contactExists = Contacts.doesContactExist('test@example.com')>

	getContactId()
		<cfset contactId = Contacts.getContactId('test@example.com')>
		
	getContacts()
	
		<cfset contactsArray = Contacts.getContacts()>
		
	getContactDetails()
	
		<cfset contactsArray = Contacts.getContacts()>
		<cfset specificContact = Contacts.getContactDetails(contactsArray[1][1])>
	
	updateContact()
	
		<cfset contactsArray = Contacts.getContacts()>
		<cfset specificContact = Contacts.getContactDetails(contactsArray[1][1])>
		<cfset changeFirtName = specificContact.setFirstName('John')>
		<cfset changeLastName = specificCOntact.setLastName('Doe')>
		<cfset updateContact = Contacts.updateContact(specificContact)>

	removeContact()
		
		<cfset contactsArray = Contacts.getContacts()>
		<cfset specificContact = Contacts.getContactDetails(contactsArray[1][1])>
		<cfset removeContact = Contacts.removeContact(specificContact)>

	deleteContact()
		
		<cfset contactsArray = Contacts.getContacts()>
		<cfset specificContact = Contacts.getContactDetails(contactsArray[1][1])>
		<cfset deleteContact = Contacts.deleteContact(specificContact)>
		
	getEvents()
	
		<cfset contactsArray = Contacts.getContacts()>
		<cfset specificContact = Contacts.getContactDetails(contactsArray[1][1])>
		<cfset getEvents = Contacts.getEvents(specificContact, 'opens')>

----
LibraryCollection.cfc
----
	
	listFolders()
	
		<cfset foldersArray = Library.listFolders()>
		
	createFolder()
		
		<cfset myFolder = new Folder('New Folder Name')>
		
	listImagesFromFolder()
	
		<cfset foldersArray = Library.listFolders()>
		<cfset specificFolder = foldersArray[1][1]>
		<cfset imagesArray = Library.listImageFromFolder(specificFolder)>

	uploadImage()
	
		*Function not complete*
		
	getImageDetails()
	
		<cfset foldersArray = Library.listFolders()>
		<cfset specificFolder = foldersArray[1][1]>
		<cfset imagesArray = Library.listImageFromFolder(specificFolder)>
		<cfset imageDetails = Library.getImageDetails(imagesArray[1][1])>

	deleteImage()
	
		<cfset foldersArray = Library.listFolders()>
		<cfset specificFolder = foldersArray[1][1]>
		<cfset imagesArray = Library.listImageFromFolder(specificFolder)>
		<cfset deleteImage = Library.deleteImage(imagesArray[1][1])>
	
	deleteImagesFromFolder()
	
		<cfset foldersArray = Library.listFolders()>
		<cfset specificFolder = foldersArray[1][1]>
		<cfset deleteImages = Library.deleteImagesFromFolder(specificFolder)>
		
----
ListsCollection.cfc
----

	addList()
	
		<cfset myList = new List('List Name')>
		<cfset addList = Lists.addList(myList)>
		
	deleteList()
	
		<cfset listsArray = Lists.getLists()>
		<cfset specificList = listsArray[1][4]>
		<cfset deleteList = Lists.deleteList(specificList)>

	getLists()
	
		<cfset listsArray = Lists.getLists()>
		
	getListMembers()
	
		<cfset listsArray = Lists.getLists()>
		<cfset specificList = listsArray[1][4]>
		<cfset listMembers = Lists.getListMembers(specificList)>
		
	getListDetails()
		
		<cfset listsArray = Lists.getLists()>
		<cfset specificList = listsArray[1][4]>
		<cfset listDetails = Lists.getListDetails(specificList)>
		
	removeListMembers()
		
		<cfset listsArray = Lists.getLists()>
		<cfset specificList = listsArray[1][4]>
		<cfset clearMembers = Lists.clearListMembers(specificList)>
			
	updateList()
	
		<cfset listsArray = Lists.getLists()>
		<cfset specificList = listsArray[1][4]>
		<cfset changeSortOrder = specificList.setSortOrder('30')>
		<cfset updateList = Lists.updateList(specificList)>
		
		