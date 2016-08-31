	<!---
	*****************************************************
	Name: 			globalConfig.cfc
	Description:	Handle the global config settings for this App
	Author:			rolando.lopez; iChameleon Group, Inc.
	Date:			9/17/2007
	*****************************************************
	--->

<cfcomponent displayname="globalConfig">
			<!--- 	
			*************************************************************************
			init()
			************************************************************************
			--->																										
		<cffunction name="init" returntype="globalConfig" output="No" hint="I initialize the component">
			<cfargument name="dsn" type="string" required="false" default="" />
			<cfargument name="configPath" type="string" required="false" default="" />
			<cfargument name="useUnderscoreNameConvention" type="string" required="false" default="" />
			<cfargument name="useUUIDConvention" type="string" required="false" default="" />
			<cfargument name="generatePrimaryKey" type="string" required="false" default="" />
			<cfargument name="collectionType" type="string" required="false" default="" />
			<cfargument name="relationshipType" type="string" required="false" default="" />
			<cfargument name="defaultFileName" type="string" required="false" default="" />
			<cfargument name="cfAdminPwd" type="string" required="false" default="" />
			
				<!--- initialize variables --->
			<cfscript>
				 setDsn( arguments.Dsn );
				 setconfigPath( arguments.configPath );
				 setuseUnderscoreNameConvention( arguments.useUnderscoreNameConvention );
				 setuseUUIDConvention( arguments.useUUIDConvention );
				 setgeneratePrimaryKey( arguments.generatePrimaryKey );
				 setcollectionType( arguments.collectionType );
				 setrelationshipType( arguments.relationshipType );
				 setdefaultFileName( arguments.defaultFileName );
				 setcfAdminPwd( arguments.cfAdminPwd );
			</cfscript>
			<cfreturn this />
		</cffunction>
		
			<!--- getMemento() --->
		<cffunction name="getMemento" access="public" returntype="struct" hint="I get local variables structure" output="false">
			<cfreturn variables.instance  />
		</cffunction>
		
			<!--- setdsn(string) --->
		<cffunction name="setdsn" access="public" returntype="void" hint="I set dsn variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.dsn = arguments.value />
		</cffunction>
		
			<!--- getdsn() --->
		<cffunction name="getdsn" access="public" returntype="string" hint="I get dsn variable" output="false">
			<cfreturn variables.instance.dsn  />
		</cffunction>
		
			<!--- setconfigPath(string) --->
		<cffunction name="setconfigPath" access="public" returntype="void" hint="I set configPath variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.configPath = arguments.value />
		</cffunction>
		
			<!--- getconfigPath() --->
		<cffunction name="getconfigPath" access="public" returntype="string" hint="I get configPath variable" output="false">
			<cfreturn variables.instance.configPath  />
		</cffunction>
		
			<!--- setuseUnderscoreNameConvention(string) --->
		<cffunction name="setuseUnderscoreNameConvention" access="public" returntype="void" hint="I set useUnderscoreNameConvention variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.useUnderscoreNameConvention = arguments.value />
		</cffunction>
		
			<!--- getuseUnderscoreNameConvention() --->
		<cffunction name="getuseUnderscoreNameConvention" access="public" returntype="string" hint="I get useUnderscoreNameConvention variable" output="false">
			<cfreturn variables.instance.useUnderscoreNameConvention  />
		</cffunction>
		
			<!--- setuseUUIDConvention(string) --->
		<cffunction name="setuseUUIDConvention" access="public" returntype="void" hint="I set useUUIDConvention variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.useUUIDConvention = arguments.value />
		</cffunction>
		
			<!--- getuseUUIDConvention() --->
		<cffunction name="getuseUUIDConvention" access="public" returntype="string" hint="I get useUUIDConvention variable" output="false">
			<cfreturn variables.instance.useUUIDConvention  />
		</cffunction>
		
			<!--- setgeneratePrimaryKey(any) --->
		<cffunction name="setgeneratePrimaryKey" access="public" returntype="void" hint="I set generatePrimaryKey variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.generatePrimaryKey = arguments.value />
		</cffunction>
		
			<!--- getgeneratePrimaryKey() --->
		<cffunction name="getgeneratePrimaryKey" access="public" returntype="string" hint="I get generatePrimaryKey variable" output="false">
			<cfreturn variables.instance.generatePrimaryKey  />
		</cffunction>
		
			<!--- setcollectionType(string) --->
		<cffunction name="setcollectionType" access="public" returntype="void" hint="I set collectionType variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.collectionType = arguments.value />
		</cffunction>
		
			<!--- getcollectionType() --->
		<cffunction name="getcollectionType" access="public" returntype="string" hint="I get collectionType variable" output="false">
			<cfreturn variables.instance.collectionType  />
		</cffunction>
		
			<!--- setrelationshipType(string) --->
		<cffunction name="setrelationshipType" access="public" returntype="void" hint="I set relationshipType variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.relationshipType = arguments.value />
		</cffunction>
		
			<!--- getrelationshipType() --->
		<cffunction name="getrelationshipType" access="public" returntype="string" hint="I get relationshipType variable" output="false">
			<cfreturn variables.instance.relationshipType  />
		</cffunction>
		
			<!--- setdefaultFileName(string) --->
		<cffunction name="setdefaultFileName" access="public" returntype="void" hint="I set defaultFileName variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.defaultFileName = arguments.value />
		</cffunction>
		
			<!--- getdefaultFileName() --->
		<cffunction name="getdefaultFileName" access="public" returntype="string" hint="I get defaultFileName variable" output="false">
			<cfreturn variables.instance.defaultFileName  />
		</cffunction>
		
			<!--- setcfAdminPwd(string) --->
		<cffunction name="setcfAdminPwd" access="public" returntype="void" hint="I set cfAdminPwd variable" output="false">
			<cfargument name="value" type="string" required="true" />
			<cfset variables.instance.cfAdminPwd = arguments.value />
		</cffunction>
		
			<!--- getcfAdminPwd() --->
		<cffunction name="getcfAdminPwd" access="public" returntype="string" hint="I get cfAdminPwd variable" output="false">
			<cfreturn variables.instance.cfAdminPwd  />
		</cffunction>
</cfcomponent>