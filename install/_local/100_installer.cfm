<cfif val(server.ColdFusion.ProductVersion) lt 8>
	<cf_html parent="#pluginmanager.view.error#">
		<div>Sorry! The Transfer Config tool requires ColdFusion 8 or later.</div>
	</cf_html>
	
	<cfinclude template="/inc/pluginmanager/view.cfm" />
	<cf_abort />
</cfif>

<cfset minversion = 3.3>
<cfset minbuild = 20091012>
<cfif not plugin.checkDependency("ontapframework",minversion,minbuild)>
	<cf_html parent="#pluginmanager.view.error#">
		<div xmlns:tap="xml.tapogee.com">
			<cfoutput>
				<p>This version of the #getLib().xmlFormat(plugin.getValue('name'))# plugin requires 
				version #minversion# build number #minbuild# or later of the onTap framework.</p>
			</cfoutput>
			
			<p><tap:text>Download the latest version at </tap:text>
			<a href="http://on.tapogee.com" /></p>
		</div>
	</cf_html>
	
	<cfinclude template="/inc/pluginmanager/view.cfm" />
	<cf_abort />
</cfif>