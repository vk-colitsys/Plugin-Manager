<cfcomponent displayname="TransferConfig" extends="plugins.transfer.transferconfig.models.TransferConfig" output="false" >
	
	<cffunction name="init" returntype="TransferConfig" output="No" hint="I initialize the component">
		<cfargument name="config" type="any" required="true" />
		<cfargument name="udf" type="any" required="true" />
		
		<cfset structAppend(arguments,config.getMemento()) />
		
			<!--- initialize variables --->
		<cfscript>
			setDsn( arguments.dsn );
			setOUdf( arguments.udf );
			setconfigPath( arguments.configPath );
			setuseNameConvention( arguments.useUnderscoreNameConvention );
			setuseUUIDConvention( arguments.useUUIDConvention );
			setgeneratePrimaryKey(arguments.generatePrimaryKey);
			setcollectionType( arguments.collectionType );
			setrelationshipType( arguments.relationshipType );
			setdefaultFileName( arguments.defaultFileName );
			
			variables.instance.packages		= structNew();
			variables.instance.xmlPackages	= structNew();
			resetOneToManyRelationships();
		</cfscript>	
			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="writeTransferFile" access="public" output="false">
		<cfset var myFile = CreateObject("component","cfc.file").init("_config/transfer.config.xml.cfm","P") />
		<cfset var config = createConfigXML() />
		
		<cfif structKeyExists(config,"success") and not config.success>
			<cfthrow type="application" message="#config.msg#" />
		</cfif>
		
		<cfset myFile.write(trim(toString(config.results))) />
	</cffunction>
	
</cfcomponent>
