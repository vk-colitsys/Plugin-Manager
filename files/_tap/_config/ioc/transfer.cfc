<cfcomponent extends="config" hint="configure the TransferConfig DI Factory">
	
	<cffunction name="configure" access="public" output="false" returntype="void">
		<cfset newContainer("transfer").init("cfc.transfer.iocfactory","tap_transfer") />
	</cffunction>
	
</cfcomponent>
