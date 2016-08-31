<cftry>
	<!--- allow other plugins to prevent the removal of this plugin by throwing an error before file removal occurs --->
	<cfloop index="cfmod" list="#ArrayToList(request.fs.templateArray('','C'))#">
	<cfinclude template="#cfmod#"></cfloop>
	
	<cfset plugin.remove()>
	<cfset htlib = getLib().html>
	<cfset htlib.childSet(pluginmanager.view.main,1,plugin.getPluginManager().goHome())>
	
	<cfcatch>
		<cfloop index="cfmod" list="#ArrayToList(request.fs.templateArray('error','C'))#">
		<cfinclude template="#cfmod#"></cfloop>
		
		<cfset htlib.childAdd(pluginmanager.view.error,"<p>#cfcatch.message#</p><p>#cfcatch.detail#</p>")>
	</cfcatch>
</cftry>
