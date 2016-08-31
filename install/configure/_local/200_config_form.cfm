<cfif plugin.isInstalled()>
	<cfset structAppend(attributes,plugin.getConfig().getMemento(),false) />
</cfif>

<cf_html return="temp" parent="#pluginmanager.view.main#">
	<div xmlns:tap="xml.tapogee.com" 
	style="border:solid black 1px; padding: 10px; background-color: #E9F0FF; width: 400px; -moz-border-radius: 8px; overflow:auto;">
		<tap:form tap:domain="C" tap:variable="installForm">
			<input type="hidden" name="netaction" value="<cfoutput>#plugin.getValue('source')#</cfoutput>/install/configure/complete" />
			
			<input type="text" name="dsn" label="Datasource" tap:required="true" />
			
			<!--- this is not used in Transfer Config despite 23 references to it in the code --->
			<!--- <input type="radio" name="useUnderscoreNameConvention" label="Underscore Name Convention" tap:boolean="true" tap:default="false" /> --->
			
			<input type="radio" name="useUUIDConvention" label="UUID Convention" tap:boolean="true" tap:default="true" />
			
			<input type="radio" name="generatePrimaryKey" label="Generate Primary Key" tap:boolean="true" tap:default="true" />
			
			<select name="collectionType" label="Collection Type">
				<option value="array">Array</option>
				<option value="struct">Struct</option>
			</select>
			
			<select name="relationshipType" label="Relationship Type">
				<option value="onetomany">One-to-Many</option>
				<option value="manytoone">Many-to-One</option>
			</select>
			
			<button type="submit" style="margin:5px;">Install</button>
		</tap:form>
		
		<a href="admin/plugins/source/transfer/transferconfig/readme.rtf" tap:domain="p" 
		target="_blank" style="float:right;">Help?</a>
	</div>
</cf_html>
