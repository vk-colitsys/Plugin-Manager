
<cfsilent>
<cfsetting showdebugoutput="false" />
	<!--- default event --->
<cfparam name="URL.event" default="transferConfig.tablesMetaData" />


<cfscript>
	sTemplatePath = 'controllers';
	eventParts = arrayNew(1);
	if(listLen(url.event, '.') gte 2 ){
		for(ixList=1; ixList lt listLen(url.event, '.'); ixList=ixList+1){
			eventParts[ixList] 	= listGetAt(url.event, ixList, '.' );
			sTemplatePath 		= sTemplatePath & '/' & eventParts[ixList];
		}
	}
	if(listLen(url.event, '.') gt 2 )
		sTemplatePath = sTemplatePath & '/' & listGetAt(url.event, listLen(url.event,'.')-1, '.');
	else
		sTemplatePath = sTemplatePath & '.cfm';
	url.action = listLast(URL.event, ".") ;
	
	includeFooter=true;
</cfscript>

</cfsilent>
<cfinclude template="layouts/layout.top.cfm" />
<cfinclude template="#sTemplatePath#" />
<cfinclude template="layouts/layout.bottom.cfm" />


  	
