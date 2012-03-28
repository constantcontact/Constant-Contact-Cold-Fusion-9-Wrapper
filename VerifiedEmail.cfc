component accessors="true" displayname="VerifiedEmail" output="false" initmethod="init" extends="Utility"
{
	property string emailAddress;
	property string id;
	property string verifiedtime;
	property string status;

	public VerifiedEmail function init
	(required string emailAddress,
	required string id,
	required string verifiedtime,
	required string status) 
	{
	setEmailAddress(arguments.emailAddress);
	setId(arguments.id);
	setVerifiedTime(arguments.verifiedtime);
	setStatus(arguments.status);
		return this;
	}

}