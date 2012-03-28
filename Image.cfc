component displayName="Image" output="false" initmethod="init" accessors="true" 
{
	property string imageName;
	property string imageUrl;
	property string height;
	property string width;
	property string description;
	property string folderName;
	property string folderLink;
	property string md5hash;
	property string fileSize;
	property string updated;
	property string imageLink;
	property string fileType;
	property struct imageUsages;
	
	public Image function init(
	required string imageName,
	string imageUrl = '',
	string height = '',
	string width = '',
	string description = '',
	string folderName = '',
	string folderLink = '',
	string md5hash = '',
	string filesize = '',
	string updated = '',
	string imageLink = '',
	string fileType = '',
	struct imageUsages = '#structNew()#') {
	
		setFolderName(arguments.folderName);
		setImageName(arguments.imageName);
		setHeight(arguments.height);
		setWidth(arguments.width);
		setDescription(arguments.description);
		setFolderName(arguments.folderName);
		setFolderLink(arguments.folderLink);
		setMd5Hash(arguments.md5hash);
		setFileSize(arguments.fileSize);
		setUpdated(arguments.updated);
		setImageLink(arguments.imageLink);
		setFileType(arguments.fileType);
		setImageUsages(arguments.imageUsages);
		
		return this;
	}

}