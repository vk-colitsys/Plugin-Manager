<cfcomponent output="false" extends="cfc.plugin">
	<cfset setValue("name","Transfer ORM Plugin")>
	<cfset setValue("version","1.0")>
	<cfset setValue("revision","")>
	<cfset setValue("releasedate","13-Oct-2009")>
	<cfset setValue("buildnumber",dateformat(getValue("releasedate"),"yyyymmdd"))>
	<cfset setValue("description","Installs the Transfer ORM system and configures it for your database.")>
	<cfset setValue("providerName","Projects onTap")>
	<cfset setValue("providerEmail","info@tapogee.com")>
	<cfset setValue("providerURL","http://on.tapogee.com")>
	<cfset setValue("install","install/license")>
	<cfset setValue("configure","install/configure")>
	<cfset setValue("remove","remove")>
	<cfset setValue("docs","transfer")>
	
	<cfset variables.sourcepath = getDirectoryFromPath(getCurrentTemplatePath())>
	
	<cffunction name="checkInstallation" access="public" output="false" returntype="string">
		<cfreturn yesnoformat(fileExists(ExpandPath("/transfer/TransferFactory.cfc"))) />
	</cffunction>
	
	<cffunction name="install" access="public" output="false" returntype="void">
		<cfargument name="settings" type="struct" required="true" />
		<cfset var installed = this.isInstalled() />
		<cfset var config = 0 />
		<cfset var ioc = getIoC() />
		<cftry>
			<cfset saveConfig(settings) />
			
			<cfif not installed>
				<cfset installFiles() />
				<cfset createDatasourceConfig() />
			</cfif>
			<cfset ioc.addContainer("transfer",CreateObject("component","cfc.ioc.ioccontainer").init("cfc.transfer.iocfactory","tap_transfer")) />
			
			<!--- write the transfer config --->
			<cfset ioc = ioc.getContainer("transfer") />
			<!--- we have to do this because the config CFC isn't used within transferconfig.cfc, so we have 2 sets of properties to update (sigh!) --->
			<cfset config = ioc.getBean("transferconfig").init(getConfig().init(),ioc.getBean("UDF")) />
			<!--- now that we've updated the properties, we can actually write the file --->
			<cfset config.writeTransferFile() />
			
			<cfif not installed>
				<cfset setInstallationStatus(true) />
			</cfif>
			
			<cfcatch>
				<cftry>
					<cfif not installed>
						<cfset this.remove() />
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
				<cfrethrow />
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="remove" access="public" output="false" returntype="void">
		<cfset removeFiles() />
		<cfset getIoC().detach("transfer") />
		<cfset setInstallationStatus(false) />
	</cffunction>
	
	<cffunction name="getFileMap" access="private" output="false">
		<cfreturn CreateObject("component","cfc.file").init("files/map.xml.cfm",variables.sourcepath,"wddx") />
	</cffunction>
	
	<cffunction name="installFiles" access="private" output="false">
		<!--- create the transfer config file here --->
		<cfset var source = variables.sourcepath />
		<cfset var map = getFileMap() />
		<cfset var myFile = CreateObject("component","cfc.file").init("files/_tap",source) />
		<cfset map.write(myFile.map()) />
		<cfset myFile.move("","P") />
	</cffunction>
	
	<cffunction name="removeFiles" access="private" output="false">
		<!--- may or may not be needed --->
		<cfset var source = variables.sourcepath />
		<cfset var map = getFileMap() />
		<cfset var myFile = CreateObject("component","cfc.file").init("","P") />
		<cfif map.exists()>
			<cfset myFile.move("files/_tap",source,map.read()) />
		</cfif>
	</cffunction>
	
	<cffunction name="getConfig" access="public" output="false" returntype="any">
		<cfif this.isInstalled()>
			<cfreturn getIoC().getBean("config","transfer") />
		<cfelse>
			<cfreturn CreateObject("component","config").init() />
		</cfif>
	</cffunction>
	
	<cffunction name="cf" access="private" output="false">
		<cfargument name="string" type="string" required="true" />
		<cfset string = replace(string,'"','""','ALL') />
		<cfset string = replace(string,"##","####","ALL") />
		<cfreturn string />
	</cffunction>
	
	<cffunction name="saveConfig" access="private" output="false">
		<cfargument name="settings" type="struct" required="true" />
		<cf_file action="write" file="#variables.sourcepath#/config.cfc"><cfoutput>
			<#trim("cfcomponent")# extends="transferconfig.models.GlobalConfig">
				<#trim("cffunction")# name="init" access="public">
					<#trim("cfscript")#>
						super.init(
							dsn="#cf(settings.dsn)#",
							configPath="/tap/_tap/config",
							useUnderscoreNameConvention=false,
							useUUIDConvention="#cf(settings.useUUIDConvention)#",
							generatePrimaryKey="#cf(settings.generatePrimaryKey)#",
							collectionType="#cf(settings.collectionType)#",
							relationshipType="#cf(settings.relationshipType)#",
							defaultFileName="transfer.config.xml.cfm"
						);
						
						return this; 
					</#trim("cfscript")#>
				</#trim("cffunction")#>
			</#trim("cfcomponent")#>
		</cfoutput></cf_file>
	</cffunction>
	
	<cffunction name="createDatasourceConfig" access="public" output="false">
		<cfset var dsn = getConfig().getDSN() />
		<cfset var xml = XmlParse(variables.sourcepath & "/datasource.xml") />
		<cfset xml.datasource.name.xmlText = dsn />
		<cffile action="write" output="#trim(toString(xml))#" 
			file="#ExpandPath('/tap/_tap/_config/transfer.datasource.xml.cfm')#" />
	</cffunction>
	
	<cffunction name="deleteConfig" access="private" output="false">
		<cftry>
			<cffile action="delete" file="#variables.sourcepath#/config.cfc" />
			<cfcatch></cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getFile" access="private" output="false">
		<cfreturn getObject("file")>
	</cffunction>
	
	<cffunction name="getMappingComponent" access="private" output="false">
		<cfreturn getFile().init("_config/mappings/transfer.cfc","P") />
	</cffunction>
	
	<cffunction name="hasMappingComponent" access="public" output="false">
		<cfreturn getMappingComponent().exists() />
	</cffunction>
	
	<cffunction name="removeMapping" access="public" output="false">
		<cfset getMappingComponent().delete() />
	</cffunction>
	
	<cffunction name="makeDirs" access="private" output="false">
		<cfargument name="abspath" type="string" required="true" />
		
		<cfif not directoryexists(getFS().getPath(abspath,"T")) and not directoryexists(abspath)>
			<cfif left(abspath,1) is not "/" and not findnocase(":",listfirst(abspath,"\/"))>
				<cfset abspath = getFS().getPath(abspath,"T") />
			</cfif>
			
			<cfset CreateObject("java","java.io.File").init(abspath).mkdirs() />
		</cfif>
	</cffunction>
	
	<cffunction name="createMapping" access="public" output="false">
		<cfargument name="abspath" type="string" required="true" />
		<cfset var mapping = getMappingComponent().getValue("filepath") />
		
		<cfif fileExists(mapping)>
			<cfreturn false />
		<cfelse>
			<cfset abspath = replace(abspath,"##","","ALL") />
			<cfset abspath = replace(abspath,'"','""','ALL') />
			
			<cfset makeDirs(abspath) />
			
			<cf_file action="write" file="#mapping#">
				<cfoutput><#trim("cfcomponent")# extends="config">
					
					<#trim("cffunction")# name="configure" access="public" output="false">
						<#trim("cfset")# addMapping("transfer","#abspath#",false) />
					</#trim("cffunction")#>
				</#trim("cfcomponent")#></cfoutput>
			</cf_file>
			<cfreturn true />
		</cfif>
	</cffunction>
	
	<cffunction name="extractArchiveTo" access="private" output="false">
		<cfargument name="archive" type="string" required="true" />
		<cfargument name="domain" type="string" required="true" />
		<cfargument name="destination" type="string" required="true" />
		<cfargument name="defaultdir" type="string" required="false" default="" />
		<cfset var dirname = listlast(destination,"/\") />
		<cfset parentdir = CreateObject("java","java.io.File").init(destination & "/../").getCanonicalPath() />
		
		<cfset archive = getObject("file").init(archive,domain,"zip") />
		<cfset archive.extract(destination="",domain=parentdir) />
		<!--- <cfset archive.delete() /> --->
		
		<cfif len(defaultdir) and dirname is not defaultdir>
			<cfset archive.init(defaultdir,parentdir).rename(dirname) />
		</cfif>
	</cffunction>
	
	<cffunction name="getArchiveFromHTTP" access="private" output="false">
		<cfargument name="archive" type="string" required="true" />
		<cfset var temp = 0 />
		<cfhttp result="temp" getasbinary="yes" url="#getDownloadURL(archive,true)#" />
		<cfreturn temp.fileContent />
	</cffunction>
	
	<cffunction name="getDownloadURL" access="public" output="false">
		<cfargument name="archive" type="string" required="false" default="transfer" />
		<cfargument name="doit" type="boolean" required="false" default="false" />
		<cfset var href = "http://#archive#.riaforge.org/index.cfm?event=action.download" />
		<cfif arguments.doit><cfset href = href & "&doit=true" /></cfif>
		<cfreturn href />
	</cffunction>
	
	<cffunction name="downloadLatestVersionTo" access="public" output="false">
		<cfargument name="package" type="string" required="true" />
		<cfargument name="path" type="string" required="false" default="#ExpandPath('/' & package)#" />
		<cfset var filename = "../#package#.zip" />
		<cfset var archive = getFS().getPath(filename,arguments.path) />
		<cfif fileExists(archive)><cffile action="delete" file="#archive#" /></cfif>
		<cffile action="write" file="#archive#" output="#getArchiveFromHTTP('transfer')#" />
		<cfset extractArchiveTo(filename,arguments.path,arguments.path,arguments.package) />
	</cffunction>
	
</cfcomponent>
