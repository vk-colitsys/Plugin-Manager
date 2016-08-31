	<!---
	*****************************************************
	Name: 			transferConfig.cfm
	Description:	Controller for Transfer Config
	Author:			roland lopez;
					roland@soft-itech.com
					www.roland-lopez.com/blog
	Date:			9/13/2007

	License: 		This work is licensed under the Creative Commons Attribution-Share Alike 3.0 License.
					To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
					or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco,
					California, 94105, USA.
	*****************************************************
	--->

<cfscript>
oTransferConfig = application.com.transferConfig;
oGlobalConfig 	= application.com.globalConfig;
</cfscript>

<cfswitch expression="#Action#">
	<cfcase value="xml">
		<cfif structKeyExists(form, 'fullFileName')>
			<cfset variables.tablesMetaData	=  oTransferConfig.createConfigXml(argumentCollection=form) />
			<cfset includeFooter	=  false/>
			<cfcontent reset="true" >
			<cfcontent type="text/xml"><cfoutput>#variables.tablesMetaData.results#</cfoutput>
		<cfelse>
			Error: you've tried to access this page directly.
		</cfif>
	</cfcase>
	<cfcase value="writeXml">
		<cfif structKeyExists(form, 'fullFileName')>
			<cfset variables.tablesMetaData	=  application.com.transferConfig.writeTransferFile(argumentCollection=form) />
			<cfinclude template="../views/vwWriteXml.cfm" />
		<cfelse>
			Error: you've tried to access this page directly.
		</cfif>
	</cfcase>
	<cfcase value="tablesMetaData">
		<cfset variables.tablesMetaData	=  application.com.transferConfig.getTablesMetaData() />
		<cfif tablesMetaData.success>
			<cfscript>
				aTables = arrayNew(1);
				aTables = tablesMetaData.results;
				oUdf	= application.com.udf;
			</cfscript>

			<cfinclude template="../views/vwTablesMetaData.cfm" />
		<cfelse>
			<cfinclude template="../views/error.cfm" />
		</cfif>
	</cfcase>
	<cfcase value = "generateConfigForm">
			<!--- form default values --->
		<cfparam name = "form.useUnderscoreNameConvention" 	default = "#oTransferConfig.getuseNameConvention()#" />
		<cfparam name = "form.useUUIDConvention" 			default = "#oTransferConfig.getuseUUIDConvention()#" />
		<cfparam name = "form.generatePrimaryKey" 			default = "#oTransferConfig.getgeneratePrimaryKey()#" />
		<cfparam name = "form.collectionType" 				default = "#oTransferConfig.getcollectionType()#" />
		<cfparam name = "form.relationshipType" 			default = "#oTransferConfig.getrelationshipType()#" />
		<cfparam name = "form.fullFileName" 				default = "#oTransferConfig.getDefaultFileName()#" />
		<cfparam name = "form.dsn" 							default = "#oTransferConfig.getdsn()#" />
		
		
		
		<cftry>
			<cfscript>
				stDataSources 	= structNew();
				success 		= true;
				oAdminApi 		= createObject("component","cfide.adminapi.administrator");
			 	oAdminApi.login( oGlobalConfig.getcfAdminPwd() );
		 		oDatasource 	= createObject("component","cfide.adminapi.datasource");
		 		stDataSources 	= oDataSource.GETDATASOURCES();
			</cfscript>
			<cfcatch type = "cfadminapiSecurityError" >
				<cfscript>success=false;</cfscript>
			</cfcatch>
			<cfcatch type = "any" >
				<cfthrow errorcode="#cfcatch.errorCode#" detail="#cfcatch.message#" >
			</cfcatch>
		</cftry>
		<cfif not success>
			<cftry>
				<cfscript>
					success = true;
					oServiceFactory = CreateObject("java", "coldfusion.server.ServiceFactory");
					stDataSources = oServiceFactory.DataSourceService.getDatasources();
				</cfscript>
				<cfcatch type="object">
					<cfscript>success = false;</cfscript>	
				</cfcatch>
				<cfcatch type = "any" >
					<cfthrow errorcode="#cfcatch.errorCode#" detail="#cfcatch.message#" >
				</cfcatch>
			</cftry>
		</cfif>
		
		
		<cfinclude template="../views/vwGenerateConfig.cfm" />
	</cfcase>
</cfswitch>