component displayname="Activity" accessors="true" initmethod="init"
{
	property string activityId;
	property string activityName;
	property string updated;
	property string activityLink;
	property string fileName;
	property string type;
	property string status;
	property string transactionCount;
	property string errors;
	property string runStartTime;
	property string runFinishTime;
	property string insertTime;
	
	public any function init(
	required string activityId,
	string activityName='',
	string updated='',
	string activityLink='',
	string type='',
	string fileName='',
	string status='',
	string transactionCount='',
	string errors='',
	string runStartTime='',
	string runFinishTime='',
	string insertTime='') {
	
		setActivityId(arguments.activityId);
		setActivityName(arguments.activityname);
		setUpdated(arguments.updated);
		setActivityLink(arguments.activityLink);
		setType(arguments.type);
		setStatus(arguments.status);
		setFileName(arguments.fileName);
		setTransactionCount(arguments.transactionCount);
		setErrors(arguments.errors);
		setRunStartTime(arguments.runStartTime);
		setRunFinishTime(arguments.runFinishTime);
		setInsertTime(arguments.insertTime);
	}
	return this;
}