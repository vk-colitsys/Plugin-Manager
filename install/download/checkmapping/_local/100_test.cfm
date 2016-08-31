<cfif plugin.checkInstallation()>
	<cfset tap.goto.domain = "C" />
	<cfset tap.goto.href = structNew() />
	<cfset tap.goto.href.netaction = plugin.getValue('source') & '/install/configure' />
<cfelse>
	<cfset plugin.removeMapping() />
	
	<cf_html return="temp" parent="#pluginmanager.view.error#">
		<div xmlns:tap="xml.tapogee.com">
			<p>The system is unable to 
			<a href="<cfoutput>#plugin.getDownloadURL()#</cfoutput>" target="_blank">download Transfer</a> 
			
			<cfif attributes.abspath is not ExpandPath("/transfer")>
				or to create a mapping to
				<div><tap:text><tap:variable name="attributes.abspath" /></tap:text></div>
			</cfif></p>
			
			<p>You'll have to install Transfer manually and try again.</p>
		</div>
	</cf_html>
</cfif>
