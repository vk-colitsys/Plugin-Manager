<cf_validate form="#variables.installForm#">
	
	<cfset tap.goto.domain = "C" />
	<cfset tap.goto.href = structNew() />
	<cfset tap.goto.href.abspath = attributes.abspath />
	<cfset tap.goto.href.configpath = attributes.configpath />
	<cfset tap.goto.href.netaction = plugin.getValue('source') & '/install/download/checkmapping' />
	
	<cfif attributes.abspath is not ExpandPath("/transfer")>
		<cfset plugin.createMapping(attributes.abspath) />
	</cfif>
	
	<cfif val(attributes.download)>
		<cfset plugin.downloadLatestVersionTo("transfer",attributes.abspath) />
	</cfif>
	
	<!--- 
		Can't download the latest version with the current version 
		because the archive is in a rar not a zip and we can't extract it automatically 
		<cfif val(attributes.downloadconfig)>
			<cfset plugin.downloadLatestVersionTo("transferconfig",attributes.configpath) />
		</cfif> 
	--->
</cf_validate>
