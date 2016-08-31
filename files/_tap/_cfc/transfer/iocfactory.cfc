<cfcomponent displayname="TransferConfig.IoCFactory" extends="cfc.ioc.iocfactory" output="false">
	<cfscript>
		define("config","plugins.transfer.config"); 
		define("udf","plugins.transfer.transferconfig.models.Udf"); 
		define("transferconfig","cfc.transfer.transferconfig"); 
		define("factory"); 
		define("transfer"); 
		define("datasource"); 
	</cfscript>
	
	<cffunction name="create_factory" access="private" output="false">
		<cfreturn CreateObject("component","transfer.TransferFactory").init(
				datasourcePath = "/tap/_tap/_config/transfer.datasource.xml.cfm", 
				configPath = "/tap/_tap/_config/transfer.config.xml.cfm") />
	</cffunction>
	
	<cffunction name="getCached_transfer" access="private" output="false">
		<cfreturn getBean("factory").getTransfer() />
	</cffunction>
	
	<cffunction name="getCached_datasource" access="private" output="false">
		<cfreturn getBean("factory").getDatasource() />
	</cffunction>
	
</cfcomponent>
