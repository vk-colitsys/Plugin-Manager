<cf_validate form="#variables.installForm#">
	<cftry>
		<cfset htlib = getLib().html />
		<cfset plugin.install(attributes) />
		
		<cfset htlib.childSet(pluginmanager.view.main,1,plugin.getPluginManager().goHome()) />
		
		<cfcatch>
			<cfset htlib.childAdd(pluginManager.view.error,"<p>#cfcatch.message#</p><p>#cfcatch.detail#</p>") />
		</cfcatch>
	</cftry>
</cf_validate>
