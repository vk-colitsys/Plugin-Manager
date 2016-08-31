<cfset plugin = getIoC().getBean("transfer","plugins") />

<cfoutput>
	<cfsavecontent variable="tap.view.content">
	#htlib.show(docPage(plugin.getValue("name") & " " 
		& plugin.getValue("version") & " " & plugin.getValue("revision")))#
	
	<p>Transfer is an Object-Relational Mapping (ORM) tool for ColdFusion, 
	written by Mark Mandel and available under the terms of 
	<a href="http://www.opensource.org/licenses/cpl1.0.php">the Common Public License</a>.
	Transfer simplifies the process of storing object data in a database and developing 
	common Create/Read/Update/Delete (CRUD) features needed by most software applications. 
	The Transfer Plugin also uses the <a href="http://transferconfig.riaforge.org">Transfer Config</a> 
	project created by Rolando Lopez (released under the 
	<a href="http://www.apache.org/licenses/LICENSE-2.0">Apache License v.2</a>) 
	to introspect your database and generate a default config file for the Transfer ORM. 
	Once the plugin is installed, the Transfer ORM is then available to the rest of your application.</p>
	
	<p>For documentation, help and resources using Transfer, see the 
	<a href="http://docs.transfer-orm.com">Transfer documentation</a> site.</p>
	
	#docSection("Config Files")#
	
	<p>Your Transfer config file and datasource config file are stored in the config directory:</p>
	
	<p class="filepath">#getFS().getPath("_config/","p")#</p>
	
	#docSection("Getting Transfer Objects")# 
	
	<p>The Transfer Plugin creates an IoC Factory for transfer objects to make it convenient 
	to get your Transfer objects. Mostly you will want to get the Transfer object, although 
	occasionally you may want the TransferFactory or the Datasource object. These objects can
	be retrieved from the IoC factory via the standard getBean(BeanName) method. The bean names 
	are Transfer, Factory and Datasource respectively. So for example, to get the Transfer 
	object, you would use code like this:</p>
	
	<pre class="codeblock">&lt;cfset orm = getIoC("tranfser").getBean("tranfser") /&gt;</pre>
	
	<p>Or to get the TransferFactory object, you would use code like this:</p>
	
	<pre class="codeblock">&lt;cfset factory = getIoC("transfer").getBean("factory") /&gt;</pre>
	
	#docSection("Changing the Database")# 
	
	<p>If you've made changes to your database after installing the Transfer plugin, then your 
	Transfer config file will be out of sync with your database. You can bring the config back 
	into sync in one of two ways. Either you can go to the plugin manager and select the configure 
	button next to the Transfer plugin and submit the form again, or you can get the TransferConfig 
	object from the IoC Factory and use that to generate a new config file. Using the form will 
	overwrite the existing Transfer config file, so you should back it up first if you've (likely) 
	made changes to it since installation. This way you can easily merge the new config with the 
	backup in a file-comparison tool like WinMerge or Beyond Compare. On the other hand, if you're 
	using a version-control system like Subversion, you may be able to simply compare the new file 
	against a previous version and merge the changes that way.</p>
	
	<p>If you'd like more control over the creation of a new config file, simply use the CreateConfigXmL() 
	method in the TransferConfig object like this:</p>
	
	<pre class="codeblock">&lt;cfset cfg = getIoC("transfer").getBean("transferconfig").createConfigXML() /&gt;
&lt;cfdump var=&quot;##cfg.results##&quot; /&gt;</pre>
	
	<p>It's important to note that the createConfigXML() function returns a structure. If an error 
	occurred while attempting to generate the XML, the structure will contain a "success" key with 
	a value of "false".</p>
	
	</cfsavecontent>
</cfoutput>
