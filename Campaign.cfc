component displayame="Campaign" output="false" initmethod="init" accessors="true" {
	property string campaignName;
	property string campaignId;
	property string campaignLink;
	property string lastEditDate;
	property string lastRunDate;
	property string status;
	property string updated;
	property string sent;
	property string opens;
	property string clicks;
	property string optOuts;
	property string bounces;
	property string forwards;
	property string spamReports;
	property string subject;
	property string fromName;
	property string fromEmail;
	property string fromEmailId;
	property string replyToEmail;
	property string replyToEmailId;
	property string campaignType;
	property string viewAsWebpage;
	property string viewAsWebpageLinkText;
	property string viewAsWebpageText;
	property string permissionReminder;
	property string permissionReminderText;
	property string greetingSalutation;
	property string greetingName;
	property string greetingString;
	property string organizationName;
	property string organizationAddress1;
	property string organizationAddress2;
	property string organizationAddress3;
	property string organizationCity;
	property string organizationState;
	property string organizationInternationalState;
	property string organizationPostalCode;
	property string organizationCountry;
	property string includeForwardEmail;
	property string forwardEmailLinkText;
	property string includeSubscribeLInk;
	property string subscribeLinkText;
	property string archiveStatus;
	property string archiveUrl;
	property string emailContentFormat;
	property string emailContent;
	property string emailTextContent;
	property string styleSheet;
	property array urls;
	property array contactLists;
	
	public Campaign function init(
	required string campaignName,
	string campaignId = 'http://api.constantcontact.com/ws/customers/#application.ccUsername#/campaigns',
	string campaignLink = '',
	string lastEditDate = '',
	string lastRunDate = '',
	string status = 'Draft',
	string updated = '',
	string sent = '',
	string opens = '',
	string clicks = '',
	string optOuts = '',
	string bounces = '',
	string forwards = '',
	string spamReports = '',
	string subject = 'Default Subject Line',
	string fromName = 'From Name',
	string fromEmail = 'fromemail@example.com',
	string fromEmailId = 'http://api.constantcontact.com/ws/customers/#application.ccUsername#/settings/emailaddresses/1',
	string replyToEmail = 'fromemail@example.com',
	string replyToEmailId = 'http://api.constantcontact.com/ws/customers/#application.ccUsername#/settings/emailaddresses/1',
	string campaignType = 'CUSTOM',
	string viewAsWebpage = 'NO',
	string viewAsWebpageLinkText = '',
	string viewAsWebpageText = '',
	string permissionReminder = 'NO',
	string permissionReminderText = 'Permission Reminder',
	string greetingSalutation = 'Dear',
	string greetingName = 'FirstName',
	string greetingString = '',
	string organizationName = '$ACCOUNT.ORGANIZATIONNAME',
	string organizationAddress1 = '$ACCOUNT.ADDRESS_LINE_1',
	string organizationAddress2 = '$ACCOUNT.ADDRESS_LINE_2',
	string organizationAddress3 = '$ACCOUNT.ADDRESS_LINE_3',
	string organizationState = '$ACCOUNT.US_STATE',
	string organizationCity = '$ACCOUNT.CITY',
	string organizationInternationalState = '$ACCOUNT.STATE',
	string organizationPostalCode = '$ACCOUNT.POSTAL_CODE',
	string organizationCountry = '$ACCOUNT.COUNTRY_CODE',
	string includeForwardEmail = 'NO',
	string forwardEmailLinkText = '',
	string includeSubscribeLink = 'NO',
	string subscribeLinkText = '',
	string archiveStatus = '',
	string archiveUrl = '',
	string emailContentFormat = 'XHTML',
	string emailTextContent = '<Text>This is the text version.</Text>',
	string emailContent = '<html lang="en" xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" 
xmlns:cctd="http://www.constantcontact.com/cctd">
<body><CopyRight>Copyright (c) 1996-2009 Constant Contact. All rights reserved.  Except as permitted under a
separate
written agreement with Constant Contact, neither the Constant Contact software, nor any content that appears on any
Constant Contact site,
including but not limited to, web pages, newsletters, or templates may be reproduced, republished, repurposed, or
distributed without the
prior written permission of Constant Contact.  For inquiries regarding reproduction or distribution of any Constant
Contact material, please
contact joesflowers@example.com.</CopyRight>
<OpenTracking/>
<!--  Do NOT delete previous line if you want to get statistics on the number of opened emails -->
<CustomBlock name="letter.intro" title="Personalization">
    <Greeting/>
</CustomBlock>
</body>
</html>',
	string styleSheet = '',
	array urls = '#arrayNew(1)#',
	array contactLists = '#arrayNew(1)#') {

		setCampaignName(arguments.campaignName);
		setCampaignLink(arguments.campaignLink);
		setCampaignId(arguments.campaignId);
		setLastEditDate(arguments.lastEditDate);
		setUpdated(arguments.updated);
		setLastRunDate(arguments.lastRunDate);
		setStatus(arguments.status);
		setSent(arguments.sent);
		setOpens(arguments.opens);
		setClicks(arguments.clicks);
		setOptOuts(arguments.optOuts);
		setBounces(arguments.bounces);
		setSpamReports(arguments.spamReports);
		setForwards(arguments.forwards);
		setSubject(arguments.subject);
		setFromName(arguments.fromName);
		setFromEmail(arguments.fromEmail);
		setFromEmailId(arguments.fromEmailId);
		setReplyToEmail(arguments.replyToEmail);
		setReplyToEmailId(arguments.replyToEmailId);
		setCampaignType(arguments.campaignType);
		setViewAsWebpage(arguments.viewAsWebpage);
		setViewAsWebpageLinkText(arguments.viewAsWebpageLinkText);
		setViewAsWebpageText(arguments.viewAsWebpageText);
		setPermissionReminder(arguments.permissionReminder);
		setPermissionReminderText(arguments.permissionReminderText);
		setGreetingSalutation(arguments.greetingSalutation);
		setGreetingName(arguments.greetingName);
		setGreetingString(arguments.greetingString);
		setOrganizationName(arguments.organizationName);
		setOrganizationAddress1(arguments.organizationAddress1);
		setOrganizationAddress2(arguments.organizationAddress2);
		setOrganizationAddress3(arguments.organizationAddress3);
		setOrganizationCity(arguments.organizationCity);
		setOrganizationState(arguments.organizationState);
		setOrganizationInternationalState(arguments.organizationInternationalState);
		setOrganizationPostalCode(arguments.organizationPostalCode);
		setOrganizationCountry(arguments.organizationCountry);
		setIncludeForwardEmail(arguments.includeForwardEmail);
		setForwardEmailLinkText(arguments.forwardEmailLinkText);
		setIncludeSubscribeLink(arguments.includeSubscribeLink);
		setSubscribeLinkText(arguments.subscribeLinkText);
		setArchiveStatus(arguments.archiveStatus);
		setArchiveUrl(arguments.archiveUrl);
		setEmailContentFormat(arguments.emailContentFormat);
		setEmailContent(arguments.emailContent);
		setEmailTextContent(arguments.emailTextContent);
		setStyleSheet(arguments.styleSheet);
		setUrls(arguments.urls);
		setContactLists(arguments.ContactLists);

	return this;
	}
}