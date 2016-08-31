<cfcomponent name="Udf" output="false">

		<!--- 	
		*************************************************************************
		Init
		************************************************************************
		--->																										
	<cffunction name="init" returntype="Udf" output="No" hint="I initialize the component">
		
		<cfreturn this />
	</cffunction>	
	
	<cfscript>
			/**
			 * Converts a query object into an array of structures.
			 * 
			 * @param query 	 The query to be transformed 
			 * @return This function returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, September 27, 2001 
			 */
		function queryToArrayOfStructures(theQuery){
			var theArray = arraynew(1);
			var cols = ListtoArray(theQuery.columnlist);
			var row = 1;
			var thisRow = "";
			var col = 1;
			for(row = 1; row LTE theQuery.recordcount; row = row + 1){
				thisRow = structnew();
				for(col = 1; col LTE arraylen(cols); col = col + 1){
					thisRow[cols[col]] = theQuery[cols[col]][row];
				}
				arrayAppend(theArray,duplicate(thisRow));
			}
			return(theArray);
		}
			//trueFalseFormat()
			
			
		
	</cfscript>
	
		<!---
		******************************************************************************** 
		trueFalseFormat()
		Author: roland lopez - Date: 8/8/2007 
		Hint: format a boolean value to True or False
		********************************************************************************
		--->
	<cffunction name = "trueFalseFormat" output = "false" access = "public" returntype = "any" hint = "format a boolean value to True or False">
		<cfargument name="bVal" type="boolean" required="true"  />
		<cfscript>
			var sReturn = '';
		</cfscript>
		<cftry>
			<cfscript>
				if(arguments.bVal)
					sReturn = 'true';
				else
					sReturn = 'false';
			</cfscript>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn sReturn />
	</cffunction>
		
		<!---
		******************************************************************************** 
		arrayFind()
		Author: roland lopez - Date: 8/9/2007 
		Hint: finds the positon of an element in an array
		********************************************************************************
		--->
	<cffunction name="arrayFind" output="false" access="public" returntype="numeric" hint="finds the positon of an element in an array">
		<cfargument name="inArray" type="array" required="true"  />
		<cfargument name="inStringToFind" type="string" required="true"  />
		
		<cfscript>	
			var iElementPosition 	= structNew();
		</cfscript>
	
		<cftry>
			<cfscript>
				iElementPosition = arguments.inArray.IndexOf( JavaCast( "string", arguments.inStringToFind ) );
				if(iElementPosition lt 0)
					iElementPosition = 0;
			</cfscript>
			<cfcatch type="any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>

		<cfreturn iElementPosition />
	</cffunction>
		
</cfcomponent>