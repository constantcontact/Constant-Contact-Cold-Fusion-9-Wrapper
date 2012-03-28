component displayname="CampaignsCollection" output="false" initmethod="init" extends="Utility"
{

/**
*@hint constructor
*/

	public CampaignsCollection function init() {
		return this;
	}

/**
*@hint Creates a Campaign in Constant Contact using the properties of the Campaign object
*@campaign Campaign to be added to Constant Contact
*/
	
	public Campaign function addCampaign(required Campaign campaign) {
		local.campaignXml = createCampaignXml(arguments.campaign);
		local.httpResponse = CTCTRequest('post', '#application.apiPath#/campaigns', local.campaignXml);
		local.campaignStruct = createCampaignStruct(local.httpResponse);
		local.newCampaign = new Campaign(argumentCollection = local.campaignStruct);
		return local.newCampaign;
	}
	
/**
*@hint Updates a Campaign in Constant Contact using the properties of the Campaign object
*@campaign Campaign to be updated
*/	
	
	public string function updateCampaign(required Campaign campaign) {
		local.campaignXml = createCampaignXml(arguments.campaign);
		local.httpResponse = CTCTRequest('put', '#arguments.campaign.getCampaignLink()#', local.campaignXml);
		return local.httpResponse;
	}
	
/**
*@hint Deletes a Campaign in Constant Contact using the properties of the Campaign object
*@campaign Campaign to be deleted in Constant Contact
*/	
	
	public void function deleteCampaign(required Campaign campaign) {
		local.httpResponse = CTCTRequest('delete', '#arguments.campaign.getCampaignLink()#');
	}
	
/**
*@hint Gets a list of 50 Campaigns, and a link to the next page of campaigns if one exists
*@page Optional URL if performing this function on a page other than the first 
*/	
	
	public array function getCampaigns(page='#application.apiPath#/campaigns') {
		local.campaignsXml = xmlParse(CTCTRequest('get', page));
		local.fullArray = arrayNew(1);
		local.campaignsArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.nextAddress = '';
		for(i=1; i LTE arrayLen(local.campaignsXml.feed.entry); i=i+1) {
			local.campaign = {
				campaignLink = application.path & local.campaignsXml.feed.entry[i].link.xmlattributes.href,
				campaignId = local.campaignsXml.feed.entry[i].id.xmlText,
				campaignName = local.campaignsXml.feed.entry[i].title.XmlText,
				updated = local.campaignsXml.feed.entry[i].updated.XmlText,
				status = local.campaignsXml.feed.entry[i].content.Campaign.status.xmlText};
			local.newCampaign = new Campaign(argumentCollection=local.campaign);
			arrayAppend(local.campaignsArray, local.newCampaign);
		}
		arrayAppend(local.fullArray, local.campaignsArray);
		local.nextLinkSearch = xmlSearch(local.campaignsXml, "//*[@rel='next']");
		if(!arrayIsEmpty(local.nextLinkSearch)) {
			local.nextAddress = application.path & local.nextLinkSearch[1].xmlattributes.href;
		}
		local.linkArray[1] = local.nextAddress;
		arrayAppend(local.fullArray, local.linkarray);
		return local.fullArray;
	}
	
/**
*@hint Searches for campaigns based off of their status
*@status Status to search for. Valid options are:  DRAFT, RUNNING, SENT and SCHEDULED
*/		
	
	public array function searchCampaigns(required string status) {
		local.searchUrl = application.apiPath & '/campaigns?status=' & arguments.status;
		local.foundCampaigns = getCampaigns(local.searchUrl);
		return local.foundCampaigns;
	}
	
/**
*@hint Returns an updated Campaign object containing all details that exist in Constant Contact
*@campaign Campaign to retrieve details for
*/	
	
	public Campaign function getCampaignDetails(required Campaign campaign) {
		local.campaignXml = xmlParse(CTCTRequest('get', '#arguments.campaign.getCampaignLink()#'));
		local.campaignStruct = createCampaignStruct(local.campaignXml);
		local.newCampaign = new Campaign(argumentCollection = local.campaignStruct);
		return local.newCampaign;
	}
	
/**
*@hint Creates XML to be used for sending Campaign information to Constant Contact 
*@campaign Campaign to create XML for
*/	
	
	private Xml function createCampaignXml(required Campaign campaign) {
		savecontent variable="local.campaignPart1" { 
		writeOutput('<entry xmlns="http://www.w3.org/2005/Atom">
		  <link href="/ws/customers/#application.ccusername#/campaigns" rel="edit" />
		  <id>#arguments.campaign.getCampaignId()#</id>
		  <title type="text"></title>
		  <updated>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</updated>
		  <author>
		    <name></name>
		  </author>
		  <content type="application/vnd.ctct+xml">
		    <Campaign xmlns="http://ws.constantcontact.com/ns/1.0/" id="#arguments.campaign.getCampaignId()#">
		      <Name>#arguments.campaign.getCampaignName()#</Name>
		      <Status>#arguments.campaign.getStatus()#</Status>
		      <Date>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</Date>
		      <Subject>#arguments.campaign.getSubject()#</Subject>
		      <FromName>#arguments.campaign.getFromName()#</FromName>
		      <ViewAsWebpage>#arguments.campaign.getViewAsWebpage()#</ViewAsWebpage>
		      <ViewAsWebpageLinkText>#arguments.campaign.getViewAsWebpageLinkText()#</ViewAsWebpageLinkText>
		      <ViewAsWebpageText>#arguments.campaign.getViewAsWebpageText()#</ViewAsWebpageText>
		      <PermissionReminder>#arguments.campaign.getPermissionReminder()#</PermissionReminder>
		      <PermissionReminderText>#arguments.campaign.getPermissionReminderText()#</PermissionReminderText>
		      <GreetingSalutation>#arguments.campaign.getGreetingSalutation()#</GreetingSalutation>
		      <GreetingName>#arguments.campaign.getGreetingName()#</GreetingName>
		      <GreetingString>#arguments.campaign.getGreetingString()#</GreetingString>
		      <OrganizationName>#arguments.campaign.getOrganizationName()#</OrganizationName>
		      <OrganizationAddress1>#arguments.campaign.getOrganizationAddress1()#</OrganizationAddress1>
		      <OrganizationAddress2>#arguments.campaign.getOrganizationAddress2()#</OrganizationAddress2>
		      <OrganizationAddress3>#arguments.campaign.getOrganizationAddress3()#</OrganizationAddress3>
		      <OrganizationCity>#arguments.campaign.getOrganizationCity()#</OrganizationCity>
		      <OrganizationState>#arguments.campaign.getOrganizationState()#</OrganizationState>
		      <OrganizationInternationalState>#arguments.campaign.getOrganizationInternationalState()#</OrganizationInternationalState>
		      <OrganizationCountry>#arguments.campaign.getOrganizationCountry()#</OrganizationCountry>
		      <OrganizationPostalCode>#arguments.campaign.getOrganizationPostalCode()#</OrganizationPostalCode>
		      <IncludeForwardEmail>#arguments.campaign.getIncludeForwardEmail()#</IncludeForwardEmail>
		      <ForwardEmailLinkText>#arguments.campaign.getForwardEmailLinkText()#</ForwardEmailLinkText>
		      <IncludeSubscribeLink>#arguments.campaign.getIncludeSubscribeLink()#</IncludeSubscribeLink>
		      <SubscribeLinkText>#arguments.campaign.getSubscribeLinkText()#</SubscribeLinkText>
		      <EmailContentFormat>#arguments.campaign.getEmailContentFormat()#</EmailContentFormat>
		      <EmailContent>#xmlFormat(arguments.campaign.getEmailContent())#</EmailContent>
		      <EmailTextContent>#xmlFormat(arguments.campaign.getEmailTextContent())#</EmailTextContent>
		      <StyleSheet></StyleSheet>
		      <ContactLists>');
		  };
		savecontent variable="local.campaignPart2" {
			for(i=1; i LTE arrayLen('#arguments.campaign.getContactLists()#'); i=i+1) {
				writeOutput('<ContactList id="#local.campaign.getContactLists()[i]#"/>');
			}
		};
		savecontent variable="local.campaignPart3" {
				writeOutput('</ContactLists>
		      <FromEmail>
		        <Email id="#arguments.campaign.getFromEmailId()#">
		        </Email>
		        <EmailAddress>#arguments.campaign.getFromEmail()#</EmailAddress>
		      </FromEmail>
		      <ReplyToEmail>
		        <Email id="#arguments.campaign.getReplyToEmailId()#">
		        </Email>
		        <EmailAddress>#arguments.campaign.getReplyToEmail()#</EmailAddress>
		      </ReplyToEmail>
		    </Campaign>
		  </content>
		  <source>
		    <id>http://api.constantcontact.com/ws/customers/#application.ccUsername#/campaigns</id>
		    <title type="text">Campaigns for customer: #application.ccUsername#</title>
		    <link href="campaigns" />
		    <link href="campaigns" rel="self" />
		    <author>
		      <name>#application.ccUsername#</name>
		    </author>
		    <updated>#dateformat(now(), "yyyy-mm-dd")#T#TimeFormat(now(), "HH:mm:ss:l")#Z</updated>
		  </source>
		</entry>');
		};       
	
	local.fullXml = local.campaignPart1 & local.campaignPart2 & local.campaignPart3; 
	return xmlParse(local.fullXml);
	}

/**
*@hint Creates a structure representing a Camapign from XML returned by CTCT
*@xml XML to create a structure out of
*/
	
	private struct function createCampaignStruct(required any campaignXml) {
		local.campaignXml = xmlParse(campaignXml);
		local.tempStruct = local.campaignXml.entry.content.Campaign;
		local.campaign = {
			campaignName = local.tempStruct.name.xmlText,
			campaignId = local.campaignXml.entry.id.xmlText,
			campaignLink = application.path & local.campaignXml.entry.link.xmlattributes.href,
			updated = local.campaignXml.entry.updated.xmltext,
			status = local.tempStruct.status.xmltext,
			sent = local.tempStruct.sent.xmltext,
			opens = local.tempStruct.opens.xmltext,
			clicks = local.tempStruct.clicks.xmltext,
			optOuts = local.tempStruct.optouts.xmltext,
			bounces = local.tempStruct.bounces.xmltext,
			forwards = local.tempStruct.forwards.xmltext,
			spamReports = local.tempStruct.spamreports.xmltext,
			subject = local.tempStruct.subject.xmltext,
			fromName = local.tempStruct.fromname.xmltext,
			fromEmail = local.tempStruct.fromemail.emailaddress.xmltext,
			replyToEmail = local.tempStruct.replytoemail.emailaddress.xmltext,
			campaignType = local.tempStruct.campaigntype.xmltext,
			viewAsWebpage = local.tempStruct.viewaswebpage.xmltext,
			viewAsWebpageLinkText = local.tempStruct.viewaswebpagelinktext.xmltext,
			viewAsWebpageText = local.tempStruct.viewaswebpagetext.xmltext,
			permissionReminder = local.tempStruct.permissionreminder.xmltext,
			greetingSalutation = local.tempStruct.greetingsalutation.xmltext,
			greetingString = local.tempStruct.greetingstring.xmltext,
			organizationName = local.tempStruct.organizationname.xmltext,
			organizationAddress1 = local.tempStruct.organizationaddress1.xmltext,
			organizationAddress2 = local.tempStruct.organizationaddress2.xmltext,
			organizationAddress3 = local.tempStruct.organizationaddress3.xmltext,
			organizationCity = local.tempStruct.organizationcity.xmltext,
			organizationState  = local.tempStruct.organizationstate.xmltext,
			organizationInternationalState  = local.tempStruct.organizationinternationalstate.xmltext,
			organizationPostalCode = local.tempStruct.organizationpostalcode.xmltext,
			organizationCountry = local.tempStruct.organizationcountry.xmltext,
			includeForwardEmail = local.tempStruct.includeforwardemail.xmltext,
			forwardEmailLinkText = local.tempStruct.forwardemaillinktext.xmltext,
			includeSubscribeLink = local.tempStruct.includesubscribelink.xmltext,
			subscribeLinkText = local.tempStruct.subscribelinktext.xmltext,
			archiveStatus = local.tempStruct.archivestatus.xmltext,
			archiveUrl = local.tempStruct.archiveurl.xmltext};
			
		if(isdefined('local.tempStruct.LastEditDate.xmltext')) {
			local.campaign.lastEditDate = local.tempStruct.lastEditDate.xmlText;
		}
				
		if(local.campaign.CampaignType EQ "CUSTOM") {
			local.campaign.greetingName = local.tempStruct.greetingname.xmltext;
			local.campaign.emailContentFormat = local.tempStruct.emailcontentformat.xmltext;
			local.campaign.emailContent = local.tempStruct.emailcontent.xmltext;
			local.campaign.emailTextContent = local.tempStruct.emailtextcontent.xmltext;
			local.campaign.styleSheet = local.tempStruct.stylesheet.xmltext;
		}
		if(local.campaign.CampaignType EQ "Sent") {
			local.campaign.urls = arrayNew(1);
			local.tempUrl = structNew();
			for(i=1; i LTE arrayLen(local.tempstruct.urls.url); i=i+1) {
				local.tempUrl.value = local.tempStruct.urls.url.value.xmltext;
				local.tempUrl.clicks = local.tempStruct.urls.url.clicks.xmltext;
				local.tempUrl.id = local.tempStruct.urls.url.xmlattributes.id;
			}
		}
		return local.campaign;
	}	

}
