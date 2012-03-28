component displayname="Settings" extends="Utility" output="false" initmethod="init" 
{
	public Settings function init() {
		return this;
	}

	public array function getVerifiedEmails() {
		local.verifiedEmailArray = arrayNew(1);
		local.responseXml = xmlParse(CTCTRequest('get', '#application.apiPath#/settings/emailaddresses'));
		for(i=1; i LTE arrayLen(local.responseXml.feed.entry); i++) {
			local.verifiedEmailStruct = {
				id = local.responseXml.feed.entry[i].content.email.xmlattributes.id,
				status = local.responseXml.feed.entry[i].content.email.status.xmlText,
				verifiedTime = local.responseXml.feed.entry[i].content.email.verifiedtime.xmlText,
				emailAddress = local.responseXml.feed.entry[i].content.email.emailAddress.xmlText};
				local.verifiedEmail = new VerifiedEmail(argumentCollection = local.verifiedEmailStruct);
			arrayAppend(local.verifiedEmailArray, local.verifiedEmail);
		}
	return local.verifiedEmailArray;
	}

}