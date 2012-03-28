<cfcomponent displayname="Utility" output="false" initmethod="init" access="public">
	<cfset variables.requireRequestBody = "post,put">
	<cffunction name="init" access="public" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="CTCTRequest" access="public" output="false" returntype="any" hint="Processes CTCT WebRequests">
		<cfargument name="method" required="true" type="string" hint="valid options: get, put, post, delete">
		<cfargument name="address" required="true" type="string">
		<cfargument name="requestValue" type="any">
		<cfscript>
		local.httpRequest = new Http(username=application.apiKey & '%' & application.ccUsername, password=application.ccPassword);
		local.httpRequest.setMethod('#arguments.method#');
		local.httpRequest.setUrl('#arguments.address#');
		local.httpRequest.addParam(type='header', name='Content-Type', value='application/atom+xml');
		local.httpRequest.addParam(type='header', name='accept', value='application/atom+xml');
		if(listContains(variables.requireRequestBody, arguments.method)) {
			local.httpRequest.addParam(type='body', value='#arguments.requestValue#'); 
		}
		local.httpResponse = local.httpRequest.send().getPrefix();
		debug(local.httpResponse, arguments.method, arguments.address);

		return local.httpResponse.fileContent;
		</cfscript>	
	</cffunction>
	
	<cffunction name="multiPartPost" access="private" output="false" returntype="any">
		<cfargument name="activityType" required="true" type="string">
		<cfargument name="lists" required="true" type="array">
		<cfargument name="dataFile" type="string">
		<cfscript>
			local.httpRequest = new Http(username=application.apiKey & '%' & application.ccUsername, password=application.ccPassword);
			local.httpRequest.setMethod('post');
			local.httpRequest.setUrl(application.apiPath & '/activities');
			local.httpRequest.addParam(type='header', name='accept', value='application/atom+xml');
			local.httpRequest.addParam(type='formField', name='activityType', value='#arguments.activityType#');
			for (i=1; i LTE arrayLen(arguments.lists); i=i+1) {
				local.httpRequest.addParam(type='formField', name='lists', value='#arguments.lists[i]#');
			}
			if(isdefined('arguments.dataFile')) {
				local.httpRequest.addParam(type='formField', name='data', value='#arguments.dataFile#');
			}
			local.httpResponse = local.httpRequest.send().getPrefix();
			debug(local.httpResponse, 'post', '#application.apiPath#/activities');

			return local.httpResponse.fileContent;
		</cfscript>
	</cffunction>


	<cffunction name="urlencodedPost" access="private" output="false" returntype="any">
		<cfargument name="uploadString" required="true" hint="encoded string to upload">
		
		<cfscript>
		local.httpRequest = new Http(username=application.apiKey & '%' & application.ccUsername, password=application.ccPassword);
		local.httpRequest.setUrl(application.apiPath & '/activities');
		local.httpRequest.setMethod('post');
		//local.httpRequest.addParam(type='header', name='Content-Type', value='multipart/form-data');
		local.httpRequest.addParam(type='header', name='Content-Type', value='application/x-www-form-urlencoded');
		local.httpRequest.addParam(type='body',value='#arguments.uploadString#');
		local.httpResponse = local.httpRequest.send().getPrefix();
			debug(local.httpResponse, 'post', '#application.apiPath#/activities');
		return local.httpResponse.fileContent;
		</cfscript>
	</cffunction>
	
	<cffunction name="exportContactsPost" access="private" output="false" returntype="any">
		<cfargument name="listId" required="true" type="string" hint="id of list to be exported" />
		<cfargument name="columns" required="true" type="array" hint="array of columns to be exported" />
		<cfargument name="fileType" type="string" default="CSV" hint="Valid: CSV, TXT" />
		<cfargument name="exportOptDate" type="boolean" default="true" hint="include optDate in export" />
		<cfargument name="exportOptSource" type="boolean" default="true" hint="include opt source in export" />
		<cfargument name="exportListName" type="boolean"  default="true" hint="include list name in export" />
		<cfargument name="sortBy" type="string" default="EMAIL_ADDRESS" hint="Valid: EMAIL_ADDRESS, DATE_DESC" />
		<cfscript>
			local.httpRequest = new Http(username=application.apiKey & '%' & application.ccUsername, password=application.ccPassword);
			local.httpRequest.setMethod('post');
			local.httpRequest.setUrl(application.apiPath & '/activities');
			local.httpRequest.addParam(type='header', name='accept', value='application/atom+xml');
			local.httpRequest.addParam(type='formField', name='activityType', value='EXPORT_CONTACTS');
			local.httpRequest.addParam(type='formField', name='listId', value="#arguments.listId#");
			local.httpRequest.addParam(type='formField', name='fileType', value="#arguments.fileType#");
			local.httpRequest.addParam(type='formField', name='exportOptDate', value="#arguments.exportOptDate#");
			local.httpRequest.addParam(type='formField', name='exportOptSource', value="#arguments.exportOptSource#");
			local.httpRequest.addParam(type='formField', name='exportListName', value="#arguments.exportListName#");
			local.httpRequest.addParam(type='formField', name='sortBy', value="#arguments.sortBy#");
			for(i=1; i LTE arrayLen(columns); i++) {
				local.httpRequest.addParam(type='formField', name='columns', value="#arguments.columns[i]#");
			}
			local.httpResponse = local.httpRequest.send().getPrefix();
			debug(local.httpResponse, 'post', '#application.apiPath#/activities');
			return local.httpResponse.fileContent;
		</cfscript>
	</cffunction>

	<cffunction name="debug" access="private" output="false" hint="file write">
		<cfargument name="httpResponse" required="true">
		<cfargument name="requestMethod" required="true" type="string">
		<cfargument name="requestAddress" required="true" type="string">
		<cfif application.debug EQ true>
			<cfset local.failedStatus = "400,401,403,404,409,415,500"> 
			<cfif listContains(local.failedStatus, arguments.httpResponse.responseHeader['status_code'])>
				<cfset responseText = xmlFormat('#arguments.httpResponse.fileContent#') >
				<cfsavecontent variable="local.errormessage">
					<cfoutput>
					Status Code: #arguments.httpResponse.statusCode#<br />
					Request Method: #arguments.requestMethod#<br />
					Request Address: #arguments.requestAddress#<br />
					Response: #responseText#<br />
					</cfoutput>
				</cfsavecontent>
				<cfthrow detail="#local.errormessage#" 
					message="HTTP Request error with Constant Contact">
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>
