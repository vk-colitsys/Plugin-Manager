<cfparam name="attributes.abspath" type="string" default="#ExpandPath('/transfer')#" />
<cfparam name="attributes.configpath" type="string" default="#ExpandPath('/transferconfig')#" />

<cf_html return="installForm" parent="#pluginmanager.view.main#">
	<div xmlns:tap="xml.tapogee.com" 
	style="border:solid black 1px; background-color: #E9F0FF; width: 400px; -moz-border-radius: 8px;">
		<tap:form action="?">
			<input type="hidden" name="netaction" value="<cfoutput>#plugin.getValue('source')#</cfoutput>/install/download/complete" />
			
			<input type="text" name="abspath" label="Transfer Location" tap:required="true" style="width:15em;" />
			<input type="checkbox" name="download" tap:boolean="Download Latest Version" tap:default="true" />
			
			<!--- 
			Can't download the latest version with the current version 
			because the archive is in a rar not a zip and we can't extract it automatically 
			
			<input type="text" name="configpath" label="Transfer Config" tap:required="true" style="width:15em" />
			<input type="checkbox" name="downloadconfig" tap:boolean="Download Latest Version" tap:default="true" />
			
			--->
			
			<button type="submit">Continue</button>
		</tap:form>
	</div>
</cf_html>
