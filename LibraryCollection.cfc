component displayname="LibraryCollection" output="false" initmethod="init" extends="Utility"
{

/**
*@hint constructor
*/

	public any function init() {
		return this;
	}
	
/**
*@hint Returns array of the 50 Folders, and a link to next page if one exists
*@page Optional URL if performing this function on a page other than the first 
*/		
	
	public array function listFolders(string page='#application.apiPath#/library/folders') {
		local.foldersXml = xmlParse(CTCTRequest('get', arguments.page));
		local.foldersArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.fullArray = arrayNew(1);
		local.nextAddress = "";
		for(i=1; i LTE arrayLen(local.foldersXml.feed.entry); i=i+1) {
			local.folder = {
				folderName = local.foldersXml.feed.entry[i].title.xmlText,
				folderLink = application.path & local.foldersXml.feed.entry[i].link.xmlattributes.href,
				id = local.foldersXml.feed.entry[i].id.xmlText};
			local.newFolder = new Folder(argumentCollection=local.folder);
		arrayAppend(local.foldersArray, local.newFolder);
		}
		arrayAppend(local.fullArray, local.foldersArray);
		local.nextLinkSearch = xmlSearch (local.foldersXml, "//*[@rel='next']");
		if (!arrayIsEmpty(local.nextLinkSearch)) {
			local.nextAddress = application.path & local.nextLinkSearch[1].xmlAttributes.href;
		}
		local.linkArray[1] = local.nextAddress;
		arrayAppend(local.fullArray, local.linkArray);
		
		return local.fullArray;
	}

/**
*@hint Adds a Folder to Constant Contact using properties of the Folder object
*@folder Folder to add to Constant Contact
*/
	
	public Folder function createFolder(required Folder folder) {
		local.newFolderXml = createFolderXml(arguments.folder);
		local.httpResponse = xmlParse(CTCTRequest('post', '#application.apiPath#/library/folders', local.newFolderXml));
		local.folderStruct = createFolderStruct(local.httpResponse);
		local.newFolder = new Folder(argumentCollection = local.folderStruct);
		return local.newFolder;
	}
	
/**
*@hint Returns 50 Images contained within a specific folder, and a link to the next page if one exists
*@folder Folder to list images for
*/	
	
	public array function listImageFromFolder(required Folder folder) {
		local.imageArray = arrayNew(1);
		local.linkArray = arrayNew(1);
		local.fullImagesArray = arrayNew(1);
		local.nextAddress = "";
		local.imageXml = xmlParse(CTCTRequest('get', arguments.folder.getFolderLink() & '/images'));
		if(isdefined('local.imageXml.feed.entry')) {
			for(i=1; i LTE arrayLen(local.imageXml.feed.entry); i=i+1) {
				local.imageStruct = {
					imageName = local.imageXml.feed.entry[i].content.image.filename.xmlText,
					imageUrl = local.imageXml.feed.entry[i].content.image.imageurl.xmlText,
					height = local.imageXml.feed.entry[i].content.image.height.xmlText,
					width = local.imageXml.feed.entry[i].content.image.width.xmlText,
					description = local.imageXml.feed.entry[i].content.image.description.xmlText,
					folderName = local.imageXml.feed.entry[i].content.image.folder.name.xmlText,
					folderLink = application.path & local.imageXml.feed.entry[i].content.image.folder.link.href.xmlText,
					md5hash = local.imageXml.feed.entry[i].content.image.md5hash.xmlText,
					fileSize = local.imageXml.feed.entry[i].content.image.filesize.xmlText,
					updated = local.imageXml.feed.entry[i].content.image.lastupdated.xmlText,
					imageLink = application.path & local.imageXml.feed.entry[i].content.image.link.href.xmlText,
					fileType = local.imageXml.feed.entry[i].content.image.filetype.xmlText};
				local.image = new Image(argumentCollection = local.imageStruct);
				arrayAppend(local.imageArray, local.image);
			}
			arrayAppend(local.fullImagesArray, local.imageArray);
				local.nextLinkSearch = xmlSearch (local.imageXml, "//*[@rel='next']");
			if (!arrayIsEmpty(local.nextLinkSearch)) {
				local.nextAddress = application.path & local.nextLinkSearch[1].xmlAttributes.href;
			}
			local.linkArray[1] = local.nextAddress;
			arrayAppend(local.fullImagesArray, local.linkArray);
			}
		
		return local.fullImagesArray;
	}

/**
*@hint Uploads an image to Constant Contact - This function is not yet complete
*@image Image to be uploaded
*/	

	public Image function uploadImage(required Image image) {
	
	}
	
/**
*@hint Returns an Image containing all details that exist in Constant Contact
*@image Image to be retrieve details on
*/
	
	public Image function getImageDetails(required Image image) {
		local.imageDetails = CTCTRequest('get', arguments.image.getImageLink());
		local.imageStruct = createImageStruct(local.imageDetails);
		local.image = new Image(argumentCollection = local.imageStruct);
		return local.image;
	}
	
/**
*@hint Deletes an image from Constant Contact
*@image Image to be deleted
*/	
	
	public string function deleteImage(required Image image) {
		local.httpResponse = CTCTRequest('delete', arguments.Image.getImageLink());
		return local.httpResponse;
	}
	
/**
*@hint Deletes all images from a folder
*@folder Folder to have its images deleted
*/	
	
	public string function deleteImagesFromFolder(required Folder folder) {
		local.deleteImages = CTCTRequest('delete', '#arguments.folder.getFolderLink()#/images');
		return local.deleteImages;
	}
	
/**
*@hint Creates XML to be used for sending Folder information to Constant Contact 
*@folder Folder to have XML generated for
*/			
	
	private xml function createFolderXml(required Folder folder) {
		savecontent variable="local.folderXml" {
			writeOutput('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
		<atom:entry xmlns:atom="http://www.w3.org/2005/Atom">
			<atom:content>
				<Folder>
					<Name>#arguments.folder.getFolderName()#</Name>
				</Folder>
			</atom:content>
		</atom:entry>');
		}
		local.folderXml = xmlParse(local.folderXml);
		return local.folderXml;
	}

/**
*@hint Creates XML to be used for sending Folder information to Constant Contact 
*@image Image to have XML generated for
*/
	
	private xml function createImageXml(required Image image) {
		savecontent variable="local.imageXml" {
			writeOutput('<atom:entry xmlns:atom="http://www.w3.org/2005/Atom">
		<atom:title>#arguments.image.getTitle()#</atom:title>
		<atom:id>#arguments.image.getId()#</atom:id>
		        <atom:content>
		                <Image>
		                <FileName>#arguments.image.getImageName()#</FileName>
		                <MD5Hash>#arguments.image.getMd5Hash()#</MD5Hash>
		                <Description>#arguments.image.getDescription()#</Description>
		                </Image>
		        </atom:content>
		</atom:entry>');
		local.folderXml = xmlParse(local.folderXml);
		return local.folderXml;
		}
	}
	
/**
*@hint Creates a structure to be used in creating an image object
*@xml XML to be converted to a structure
*/		
	
	private struct function createImageStruct(required xml imageXml) {
		local.imageXml = xmlParse(arguments.imageXml);
		local.imageUsages = structNew();
		if(isdefined('local.imageXml.entry.content.image.imageUsages.imageusage')) {
			for(i=1; i LTE arrayLen(local.imageXml.entry.content.image.imageUsages); i=i+1) {
				local.imageUsages = {
					name = local.imageXml.entry.content.image.imageUsages[i].imageusage.name.xmlText,
					campaignLink = application.path & local.imageXml.entry.content.image.imageUsages[i].imageusage.link.href.xmlText};
			}
		}	
		local.imageStruct = {
			imageName = local.imageXml.entry.content.image.filename.xmlText,
			imageUrl = local.imageXml.entry.content.image.imageurl.xmlText,
			height = local.imageXml.entry.content.image.height.xmlText,
			width = local.imageXml.entry.content.image.width.xmlText,
			description = local.imageXml.entry.content.image.description.xmlText,
			md5hash = local.imageXml.entry.content.image.md5hash.xmlText,
			fileSize = local.imageXml.entry.content.image.filesize.xmlText,
			updated = local.imageXml.entry.content.image.lastupdated.xmlText,
			imageUsages = local.imageUsages,
			imageLink = application.path & local.imageXml.entry.link.xmlAttributes.href,
			fileType = local.imageXml.entry.content.image.filetype.xmlText};
		return local.imageStruct;
	}
	
/**
*@hint Creates a structure to be used in creating a Folder object
*@xml XML to be converted to a structure
*/	
	
	private struct function createFolderStruct(required xml folderXml) {
		local.folderXml = xmlParse(arguments.folderXml);
		local.folder = {
			folderName = local.folderXml.entry.content.folder.name.xmltext,
			id = local.folderXml.entry.id.xmlText,
			folderLink = local.folderXml.entry.link.xmlAttributes.href};
		return local.folder;
	}
}

