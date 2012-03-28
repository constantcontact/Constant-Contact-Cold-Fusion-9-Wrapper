component displayname="folder" output="false" initmethod="init" accessors="true"
{
	property string folderName;
	property string folderLink;
	property string id;

	public Folder function init(
	required string folderName,
	string folderLink = '',
	string id = ''){
	
		setFolderName(arguments.folderName);
		setFolderLink(arguments.folderLink);
		setId(arguments.id);
		
		return this;
	}


}