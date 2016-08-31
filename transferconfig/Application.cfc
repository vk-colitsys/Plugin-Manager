	<!---
	*****************************************************
	Name: 			Application.cfc
	Description:	TransferConfig Application file
	Author:			roland lopez; iChameleon Group, Inc.
	Date:			8/6/2007
	
	License: 		This work is licensed under the Creative Commons Attribution-Share Alike 3.0 License. 
					To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ 
					or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, 
					California, 94105, USA.
	*****************************************************
	--->

<cfcomponent>
		<!--- Modify the Name of the application--->
	<cfset this.name = hash(getCurrentTemplatePath() & cgi.SERVER_NAME) /> 
	<cfset this.clientManagement = false /> 
	<cfset this.sessionManagement = true /> 
	<cfset this.sessionTimeout = createTimeSpan(0,0,30,0) /> 
	<cfset this.setClientCookies = false />
		
<cffunction name="onApplicationStart" returnType="boolean" output="false"> 

	<cfscript>
		var stProperties = createObject( 'component','models.environment' ).init( 'config/environment.xml.cfm' ).getEnvironmentByUrl( CGI.SERVER_NAME );
	</cfscript>
	
	<cfscript>
		application.com.globalConfig 	= createObject( 'component','models.globalConfig' ).init( argumentCollection=stProperties );	
		application.com.udf				= createObject( 'component','models.Udf' ).init();
		application.com.transferConfig	= createObject( 'component','models.TransferConfig' ).init( argumentCollection=application.com.globalConfig.getMemento(), oUdf=application.com.udf );
	</cfscript>
	<cfreturn true> 
</cffunction> 

<cffunction name="onApplicationEnd" returnType="void"  output="false"> 
	<cfargument name="applicationScope" required="true">
	<!--- Place Here any application end code --->
</cffunction>

<cffunction name="onSessionStart" returnType="void" output="false"> 
	<!--- Place Here any session start code --->
</cffunction> 

<cffunction name="onSessionEnd" returnType="void" output="false"> 
	<cfargument name="sessionScope" type="struct" required="true"> 
	<cfargument name="appScope" type="struct" required="false"> 
	<!--- Place Here any session end code --->
</cffunction> 

<cffunction name="onRequestStart" returnType="void" output="false"> 
		<cfif structKeyExists(url, "flush")>
			<cfobjectcache action= "clear" />
			
			<cfswitch expression="#URL.flush#">
				<!--- application --->
				<cfcase value="app">
					<cfset onApplicationStart() />
				</cfcase>
				
				<!--- session --->
				<cfcase value="ses">
					<cfset onSessionStart() />
				</cfcase>
				
				<!--- all --->
				<cfdefaultcase>
					<cfset onApplicationStart() />
					<cfset onSessionStart() />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		
		
</cffunction> 

 
</cfcomponent>