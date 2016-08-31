	<!---
	*****************************************************
	Name: 			TransferConfig.cfc
	Description:	I handle the creation of Transfer (xml) config file.
	Author:			Roland Lopez; iChameleon Group, Inc.
					roland@soft-itech.com
					www.roland-lopez.com/blog
	Date:			8/6/2007
	
	License: 		This work is licensed under the Creative Commons Attribution-Share Alike 3.0 License. 
					To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ 
					or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, 
					California, 94105, USA.
	*****************************************************
	--->
<cfcomponent displayname="TransferConfig" output="false" >
	
		<!--- 	
		*************************************************************************
		init()
		************************************************************************
		--->																										
	<cffunction name="init" returntype="TransferConfig" output="No" hint="I initialize the component">
		<cfargument name="dsn" type="string" required="true"  />
		<cfargument name="oUdf" type="transferConfig.models.Udf" required="true"  />
		<cfargument name="configPath" type="string" required="true"  />
		<cfargument name="useUnderscoreNameConvention" type="boolean" required="false" default="false"  />
		<cfargument name="useUUIDConvention" type="boolean" required="false" default="false"  />
		<cfargument name="generatePrimaryKey" type="boolean" required="false" default="true"/>
		<cfargument name="collectionType" type="string" required="false" default="array" />
		<cfargument name="relationshipType" type="string" required="false" default="oneToMany"/>
		<cfargument name="defaultFileName" type="string" required="false" default="transferX.xml"/>
		
			<!--- initialize variables --->
		<cfscript>
			setDsn( arguments.dsn );
			setOUdf( arguments.oUdf );
			setconfigPath( arguments.configPath );
			setuseNameConvention( arguments.useUnderscoreNameConvention );
			setuseUUIDConvention( arguments.useUUIDConvention );
			setgeneratePrimaryKey(arguments.generatePrimaryKey);
			setcollectionType( arguments.collectionType );
			setrelationshipType( arguments.relationshipType );
			setdefaultFileName( arguments.defaultFileName );
			
			variables.instance.packages		= structNew();
			variables.instance.xmlPackages	= structNew();
			resetOneToManyRelationships();
		</cfscript>	
			
		<cfreturn this />
	</cffunction>

		<!---
		******************************************************************************** 
		getTablesMetaData()
		Author: Roland Lopez - Date: 8/6/2007 
		Hint: I get tables metadata from a database
		********************************************************************************
		--->
	<cffunction name = "getTablesMetaData" output = "false" access = "public" returntype = "struct" hint = "I get tables metadata from a database">
		<cfscript>	
			var stTablesMetadata 		= structNew();
			var columns					= structNew();
			var foreignkeys				= structNew();
			var relationships			= structNew();
			var ixTable					= 0;
			var ixRel					= 0;
			stTablesMetadata.success 	= true;
			stTablesMetadata.msg		= 'Data retrieved successfully.';
			stTablesMetadata.results 	= arrayNew(1);
			resetOneToManyRelationships();
		</cfscript>
	
		<cftry>
			<cfscript>
				stTablesMetadata.results =  variables.instance.oUDF.queryToArrayOfStructures( getTables().results );
			</cfscript>
			
			<cfloop index="ixTable" from="1" to="#arrayLen(stTablesMetadata.results)#">
				<cfset columns			=  getColumns(stTablesMetadata.results[ixTable].table_name) />
				<cfset foreignkeys		=  getForeignkeys(stTablesMetadata.results[ixTable].table_name) />
				
				<cfset stTablesMetadata.results[ixTable].columns 		= variables.instance.oUdf.queryToArrayOfStructures(columns.results) />
				<cfset stTablesMetadata.results[ixTable].foreignKeys 	= variables.instance.oUdf.queryToArrayOfStructures(foreignkeys.results) />
				
				<cfset relationships	=  getRelationships(stTablesMetadata.results[ixTable]) />
				<cfset stTablesMetadata.results[ixTable].relationships 	= relationships.results />
			</cfloop>
			<cfloop index="ixTable" from="1" to="#arrayLen(stTablesMetadata.results)#">
				<cfloop index="ixRel" from="1" to="#arrayLen(variables.instance.aOneToManyRelationships)#">
					<cfscript>
						if(stTablesMetadata.results[ixTable].table_name eq variables.instance.aOneToManyRelationships[ixRel].localTable){
							arrayAppend(stTablesMetadata.results[ixTable].relationships,variables.instance.aOneToManyRelationships[ixRel]);
						}
					</cfscript>
				</cfloop>
			</cfloop>
			
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
				<cfscript>
					stTablesMetadata.success = false;
					stTablesMetadata.msg = cfcatch.message;
					
				</cfscript>
			</cfcatch>
		</cftry>

		<cfreturn stTablesMetadata />
	</cffunction>
	
		<!---
		******************************************************************************** 
		writeTransferFile()
		Author: Roland Lopez - Date: 8/8/2007 
		Hint: I get a valid XML and write it to a specified file.
		********************************************************************************
		--->
	<cffunction name = "writeTransferFile" output = "false" access = "public" returntype = "struct" hint = "I get a valid XML and write it to a specified file.">
		<cfargument name="fullFileName" type="string" required="false" default="transfer.xml"  />
		<cfargument name="collectionType" type="string" required="false"  />
		<cfargument name="dsn" type="string" required="false"  />
		
		<cfscript>	
			var stWriteTransferFile 	= structNew();
			var configXml				= '';
			
			stWriteTransferFile.success	= true;
			stWriteTransferFile.msg		= 'Data retrieved successfully.';
			stWriteTransferFile.results = '';
			stWriteTransferFile.writtenTo = '#expandPath(variables.instance.configPath)#\#arguments.fullFileName#';
		</cfscript>
	
		<cftry>
			<cfscript>
				configXml = createConfigXml(argumentCollection=arguments).results;
			</cfscript>
			<cffile 
				action		= "write"
				file		= "#expandPath(variables.instance.configPath)#\#arguments.fullFileName#"
				output		= "#configXml#"
				addNewLine	= "yes"
				fixNewLine	= "no" />
				
			<cfcatch type = "any">
				<cfscript>
					stWriteTransferFile.success = false;
					stWriteTransferFile.msg		= cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
		
		<cfreturn stWriteTransferFile />
	</cffunction>
	
	<cffunction name = "createConfigXml" output = "false" access = "public" returntype = "struct" hint = "I create the Transfer XML config file">
		<cfargument name="useUnderscoreNameConvention" type="boolean" required="false"  />
		<cfargument name="useUUIDConvention" type="boolean" required="false"  />
		<cfargument name="generatePrimaryKey" type="boolean" required="false"  />
		<cfargument name="collectionType" type="string" required="false"  />
		<cfargument name="relationshipType" type="string" required="false"  />
		<cfargument name="dsn" type="string" required="false"  />
		
		<cfscript>	
			var stXmlConfigFile 	= structNew();
			var tablesMetaData		= '';
			var ix_package			= 1;
			var stPrimaryKey		= structNew();
			var arrColumns			= arrayNew(1);
			var arrRelationships	= arrayNew(1);
			var arrPackages			= arrayNew(1);
			var isArrangedInPackages= false;
			
			stTablesMetadata.success	= true;
			stTablesMetadata.msg		= 'Data retrieved successfully.';
			stTablesMetadata.results 	= '';
			
			if(structKeyExists( arguments,'useUnderscoreNameConvention' ))
				setuseNameConvention( arguments.useUnderscoreNameConvention );
			if(structKeyExists( arguments,'dsn' ))
				setDsn( arguments.dsn );
				
			tablesMetaData 			= getTablesMetaData();
			tablesMetaData.results 	= assignManyToManyRelationships( tablesMetaData.results ).results;
			
			
		</cfscript>

		
		<cftry>
			<cfscript>
			arrPackages = getPackages(tablesMetaData.results);
			isArrangedInPackages = arrangeInPackages(argumentCollection=arguments,arrTables=tablesMetaData.results,arrPackages=arrPackages);
			if( isArrangedInPackages ){
				packagesToXml(argumentCollection=arguments);
			}
			</cfscript>
			<!--- <cfdump var = "#variables.instance.useNameConvention#" label = "hey" />
			<cfdump var = "#arrPackages#" label = "arrPackages" />
			<cfdump var = "#variables.instance.packages#" label = "" />
			<cfdump var = "#isArrangedInPackages#" label = "isArrangedInPackages" />
			<cfabort /> --->
			
			<cfsavecontent variable="stXmlConfigFile.results"><cfoutput><?xml version="1.0" encoding="UTF-8"?>
<transfer xsi:noNamespaceSchemaLocation="xsd/transfer.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<objectDefinitions>
		#variables.instance.xmlPackages#	
	</objectDefinitions>
</transfer>
</cfoutput>
			</cfsavecontent>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
				<cfscript>
					stXmlConfigFile.success = false;
					stXmlConfigFile.msg = cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
		
		<cfreturn stXmlConfigFile />
	</cffunction>
		
		
		<!---
		******************************************************************************** 
		getTables()
		Author: Roland Lopez - Date: 8/6/2007 
		Hint: I get the specified database tables
		********************************************************************************
		--->
	<cffunction name="getTables" output="false" access="public" returntype="struct" hint="I get the specified database tables">
		<cfscript>	
			var stTables 		= structNew();
			stTables.success 	= true;
			stTables.msg		= 'Data retrieved successfully.';
			stTables.results 	= '';
			qTablesAndViews		= '';
			qTablesOnly			= '';
		</cfscript>
	
		<cftry>
			<cfdbinfo datasource="#variables.instance.dsn#" type="tables" name="qTablesAndViews"  />
			<cfcatch type = "any">
				<cfscript>
					stTables.success = false;
					stTables.msg	= cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
		
		<cftry>
			<cfquery name = "qTablesOnly" dbtype="query" >
				SELECT remarks,
						table_name,
						table_type
					FROM qTablesAndViews
						WHERE table_type like 'TABLE' AND
								table_name not like 'sys%'
			</cfquery>
			<cfcatch type = "database">
				<cfscript>
					stTables.success = false;
					stTables.msg	= cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>

		<cfscript>
			stTables.results = qTablesOnly;
		</cfscript>

		<cfreturn stTables />
	</cffunction>

		<!---
		******************************************************************************** 
		getColumns()
		Author: Roland Lopez - Date: 8/6/2007 
		Hint: I get the columns of a specified table
		********************************************************************************
		--->
	<cffunction name = "getColumns" output = "false" access = "public" returntype = "struct" hint = "I get the columns of a specified tables">
		<cfargument name="tableName" type="string" required="true"  />
	
		<cfscript>	
			var stColumns 	= structNew();
			stColumns.success 	= true;
			stColumns.msg		= 'Data retrieved successfully.';
			stColumns.results 	= '';
		</cfscript>
	
		<cftry>
			<cfdbinfo datasource="#variables.instance.dsn#" type="columns" name="stColumns.results" table="#arguments.tableName#" />
			<cfcatch type = "any">
				<cfscript>
					stColumns.success = false;
					stColumns.msg	= cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
	
		<cfreturn stColumns />
	</cffunction>

		<!---
		******************************************************************************** 
		getForeignkeys()
		Author: Roland Lopez - Date: 8/6/2007 
		Hint: I get the columns of a specified table
		********************************************************************************
		--->
	<cffunction name = "getForeignkeys" output = "false" access = "public" returntype = "struct" hint = "I get the getForeignkeys of a specified table">
		<cfargument name="tableName" type="string" required="true"  />
	
		<cfscript>	
			var stForeignkeys 		= structNew();
			stForeignkeys.success 	= true;
			stForeignkeys.msg		= 'Data retrieved successfully.';
			stForeignkeys.results 	= '';
		</cfscript>
	
		<cftry>
			<cfdbinfo datasource="#variables.instance.dsn#" type="foreignkeys" name="stForeignkeys.results" table="#arguments.tableName#" />
			<cfcatch type = "any">
				<cfscript>
					stForeignkeys.success = false;
					stForeignkeys.msg = cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
	
		<cfreturn stForeignkeys />
	</cffunction>

		<!---
		******************************************************************************** 
		getRelationships()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I set the relationships of a table on transfer friendly format 
		********************************************************************************
		--->
	<cffunction name = "getRelationships" output = "false" access = "private" returntype = "struct" hint = "I set the relationships of a table on transfer friendly format ">
		<cfargument name="stTable" type="struct" required="true"  />
	
		<cfscript>	
			var stCreatedRelations 		= structNew();
			var stRelationships 		= arrayNew(1);
			var col 					= 1;
			var rel						= 1;
			var stOrder					= structNew();
			var ixOneToMany				= 0;
			stCreatedRelations.success 	= true;
			stCreatedRelations.msg		= 'Relationships created successfully.';
			stCreatedRelations.results 	= '';
			
		</cfscript>
		<cftry>
			<cfscript>
				if(not isJoinedTable( arguments.stTable )){
					for( col=1; col lte arrayLen(arguments.stTable.columns); col++){
						if( arguments.stTable.columns[col].is_foreignkey ){
 							
 							
							 	//oneToMany
							/* stRelationships[rel] 		= structNew();
							stRelationships[rel].type 	= 'onetomany';
							stRelationships[rel].name 	= getObjectName(arguments.stTable.table_name) & '_' & arguments.stTable.columns[col].referenced_primarykey;
							stRelationships[rel].linkTo = getPackageName( arguments.stTable.table_name ) & '.' & getObjectName( arguments.stTable.table_name );
							stRelationships[rel].linkColumn 	= arguments.stTable.columns[col].column_name;
							
							stOrder = getRelationshipOrder(arguments.stTable.columns).results;
							stRelationships[rel].orderProperty 	= stOrder.property;
							stRelationships[rel].order 			= stOrder.order;
							stRelationships[rel].localColumn 	= arguments.stTable.columns[col].referenced_primarykey;
							stRelationships[rel].localTable 	= arguments.stTable.columns[col].referenced_primarykey_table;
							rel++; */
							ixOneToMany = arrayLen(variables.instance.aOneToManyRelationships)+1;
							variables.instance.aOneToManyRelationships[ixOneToMany] = structNew();
							variables.instance.aOneToManyRelationships[ixOneToMany].type 	= 'onetomany';
							variables.instance.aOneToManyRelationships[ixOneToMany].name 	= getObjectName(arguments.stTable.table_name); //& '_' & arguments.stTable.columns[col].referenced_primarykey;
							variables.instance.aOneToManyRelationships[ixOneToMany].linkTo = getPackageName( arguments.stTable.table_name ) & '.' & getObjectName( arguments.stTable.table_name );
							variables.instance.aOneToManyRelationships[ixOneToMany].linkColumn 	= arguments.stTable.columns[col].column_name;
							
							stOrder = getRelationshipOrder(arguments.stTable.columns).results;
							variables.instance.aOneToManyRelationships[ixOneToMany].orderProperty 	= stOrder.property;
							variables.instance.aOneToManyRelationships[ixOneToMany].order 			= stOrder.order;
							variables.instance.aOneToManyRelationships[ixOneToMany].localColumn 	= arguments.stTable.columns[col].referenced_primarykey;
							variables.instance.aOneToManyRelationships[ixOneToMany].localTable 	= arguments.stTable.columns[col].referenced_primarykey_table;
							ixOneToMany++;
								//manytoone
							stRelationships[rel] 		= structNew();
							stRelationships[rel].type 	= 'manytoone';
							stRelationships[rel].name 	= getObjectName(arguments.stTable.columns[col].referenced_primarykey_table); //& '_' & arguments.stTable.columns[col].column_name;
							stRelationships[rel].linkTo = getPackageName( arguments.stTable.columns[col].referenced_primarykey_table ) & '.' & getObjectName( arguments.stTable.columns[col].referenced_primarykey_table );
							stRelationships[rel].linkColumn = arguments.stTable.columns[col].column_name;
							stRelationships[rel].localColumn = arguments.stTable.columns[col].column_name;
							rel++;
						}
					}
				} else{
					stRelationships[rel] = structNew();
					stRelationships[rel].type 			= 'manytomany';
					stRelationships[rel].name 			= getObjectName(arguments.stTable.columns[2].referenced_primarykey_table);
					stRelationships[rel].linkTo1 		= getPackageName( arguments.stTable.columns[1].referenced_primarykey_table ) & '.' & getObjectName( arguments.stTable.columns[1].referenced_primarykey_table );
					stRelationships[rel].linkTo2 		= getPackageName( arguments.stTable.columns[2].referenced_primarykey_table ) & '.' & getObjectName( arguments.stTable.columns[2].referenced_primarykey_table );
					stRelationships[rel].linkColumn1 	= arguments.stTable.columns[1].column_name;
					stRelationships[rel].linkColumn2 	= arguments.stTable.columns[2].column_name;
					stRelationships[rel].table			= arguments.stTable.table_name;
					stRelationships[rel].collectionType = variables.instance.collectionType;
					
					//stOrder = getRelationshipOrder(arguments.stTable.columns).results;
					stRelationships[rel].orderProperty 	=  arguments.stTable.columns[2].referenced_primarykey;
					stRelationships[rel].order 			= 'asc';
				} 
				stCreatedRelations.results 	= stRelationships;
			</cfscript>
			<cfcatch type = "any">
				<cfdump var = "#stOrder#" label = "stOrder" />
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
				<cfscript>
					stCreatedRelations.success = false;
					stCreatedRelations.msg = cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>

		<cfreturn stCreatedRelations />
	</cffunction>

		<!---
		******************************************************************************** 
		isJoinedTable()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I check a if a table is a joined table
		********************************************************************************
		--->
	<cffunction name = "isJoinedTable" output = "false" access = "private" returntype = "boolean" hint = "I check a if a table is a joined table">
		<cfargument name="stTable" type="struct" required="true"  />
		<cfscript>	
			var isJoinedTable 	= false;
			var cols = arrayNew(1);
		</cfscript>
	
		<cftry>
			<cfif arrayLen(arguments.stTable.columns) eq 2>
				<cfset cols	=  arguments.stTable.columns />
				<cfif (cols[1].is_foreignKey and cols[1].is_primaryKey) and (cols[2].is_foreignKey and cols[2].is_primaryKey) >
					<cfset isJoinedTable	=  true />
				</cfif>
			</cfif>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />					
			</cfcatch>
		</cftry>
	
		<cfreturn isJoinedTable />
	</cffunction>
		
		<!---
		******************************************************************************** 
		getPackageName()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I get a package name
		********************************************************************************
		--->
	<cffunction name = "getPackageName" output = "false" access = "private" returntype = "string" hint = "I get a package name">
		<cfargument name="tableName" type="string" required="true"  />
		<cfscript>	
			var sPackageName = '';
		</cfscript>
	
		<cftry>
			<cfscript>
				if( variables.instance.useNameConvention )
					sPackageName = listFirst( arguments.tableName,'_');
				else
					sPackageName = arguments.tableName;
			</cfscript>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn sPackageName />
	</cffunction>
		
		<!---
		******************************************************************************** 
		getObjectName()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I get a object name
		********************************************************************************
		--->
	<cffunction name = "getObjectName" output = "false" access = "private" returntype = "string" hint = "I get a object name">
		<cfargument name="tableName" type="string" required="true"  />
		<cfscript>	
			var sObjectName = '';
		</cfscript>
	
		<cftry>
			<cfscript>
				if( variables.instance.useNameConvention and listLen(arguments.tableName, '_') gt 1)
					sObjectName = listGetAt( arguments.tableName,2,'_');
				else
					sObjectName = arguments.tableName;
			</cfscript>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn sObjectName />
	</cffunction>
	
		<!---
		******************************************************************************** 
		getPrimaryKey()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I get the primary key of a table
		********************************************************************************
		--->
	<cffunction name = "getPrimaryKey" output = "false" access = "private" returntype = "struct" hint = "I get the primary key of a table">
		<cfargument name="arrColumns" type="array" required="true"  />
		<cfscript>	
			var stPrimaryKey 	= structNew();
			var ixCol = 0;
		</cfscript>
	
		<cftry>
			<cfscript>
				for( ixCol=1; ixCol lte arrayLen(arguments.arrColumns); ixCol++){
					if(arguments.arrColumns[ixCol].is_primaryKey)
						stPrimaryKey = 	arguments.arrColumns[ixCol];
						break;
				}
			</cfscript>
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn stPrimaryKey />
	</cffunction>
		
		<!---
		******************************************************************************** 
		getColumnType()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I get a transfer friendly column type for a specified db column type
		********************************************************************************
		--->
	<cffunction name = "getColumnType" output = "false" access = "private" returntype = "string" hint = "I get a transfer friendly column type for a specified db column">
		<cfargument name="sDbColumn" type="struct" required="true"  />
		<cfscript>	
			var sColumnType = '';
			var reDateType	= '[a-zA-Z]*date[a-zA-Z]*|[a-zA-Z]*time[a-zA-Z]*]]';
			var reNumericType	= '[a-zA-Z]*numeric[a-zA-Z]*|[small|long|tiny|big]*int[a-zA-Z]*|[a-zA-Z]*money[a-zA-Z]*|[a-zA-Z\(\) ]*identity[a-zA-Z]*|[a-zA-Z]*float[a-zA-Z]*';
			var columnFound = false; 
		</cfscript>
	
		<cftry>
			<!--- <cfscript>
				if(reFindNoCase( reDateColName,arguments.arrColumns[ixCol].column_name )){
					if(reFindNoCase( reDateType,arguments.arrColumns[ixCol].type_name )){
						stOrder.results.order 	 = 'desc';
						stOrder.results.property = arguments.arrColumns[ixCol].column_name;
						columnFound = true;
						break;
					}
				}						
			</cfscript>		 --->
			
			
			<cfswitch expression="#arguments.sDbColumn.type_name#">
				<cfcase value="varchar,char,text" delimiters=",">
					<cfif variables.instance.useUUIDConvention and arguments.sDbColumn.column_size eq 35 and arguments.sDbColumn.type_name eq 'char'>
						<cfset sColumnType = 'UUID' />
					<cfelse>
						<cfset sColumnType = 'string' />
					</cfif>
				</cfcase>
				<cfcase value="numeric,smallint,numeric() identity,bigint,integer,decimal" delimiters=",">
					<cfset sColumnType = 'numeric' />
				</cfcase>
				<cfcase value="boolean,bit" delimiters=",">
					<cfset sColumnType = 'boolean' />
				</cfcase>
				<cfcase value="date,datetime,smalldatetime,timestamp" delimiters=",">
					<cfset sColumnType = 'date' />
				</cfcase>
				<cfcase value="uniqueidentifire" delimiters=",">
					<cfset sColumnType = 'GUID' />
				</cfcase>
				<cfcase value="uuid" delimiters=",">
					<cfset sColumnType = 'UUID' />
				</cfcase>
				<cfdefaultcase>
					<cfset sColumnType	=  'string'/>
				</cfdefaultcase>
			</cfswitch>
				
						
			<cfcatch type = "any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn sColumnType />
	</cffunction>
	
		<!---
		******************************************************************************** 
		assignManytoManyRelationships()
		Author: Roland Lopez - Date: 8/7/2007 
		Hint: I assign the manytomany relationships to the proper objects
		********************************************************************************
		--->
	<cffunction name = "assignManytoManyRelationships" output = "false" access = "private" returntype = "struct" hint = "I assign the manytomany relationships to the proper objects. getRelationships() must be executed first.">
		<cfargument name="arrTables" type="array" required="true"  />
		<cfscript>	
			var stAssigned 	= structNew();
			var assignTo	= '';
			var ixTable		= 0;
			var ixTable2		= 0;
			
			stAssigned.success 	= true;
			stAssigned.msg		= 'Relationships assigned successfully.';
			stAssigned.results 	= arrayNew(1);
		</cfscript>
	
		<cftry>
			
			<cfscript>
				for( ixTable=1; ixTable lte arrayLen(arguments.arrTables); ixTable++){
					if(isJoinedTable( arguments.arrTables[ixTable] )){
						assignTo = arguments.arrTables[ixTable].columns[1].referenced_primarykey_table;
						for( ixTable2=1; ixTable2 lte arrayLen(arguments.arrTables); ixTable2++){
							if(arguments.arrTables[ixTable2].table_name eq assignTo){
								arrayAppend(arguments.arrTables[ixTable2].relationships,arguments.arrTables[ixTable].relationShips[1]);
								arrayDeleteat(arguments.arrTables,ixTable);
							}
						}
					}
				}
				stAssigned.results = arguments.arrTables;
				
			</cfscript>
			
			<cfcatch type = "any">
				<cfscript>
					stAssigned.success = false;
					stAssigned.msg = cfcatch.message;
				</cfscript>
			</cfcatch>
		</cftry>
	
		<cfreturn stAssigned />
	</cffunction>
	
		<!---
		******************************************************************************** 
		getRelationshipOrder()
		Author: Roland Lopez - Date: 8/8/2007 
		Hint: I get the transfer order properties of a relationship
		********************************************************************************
		--->
	<cffunction name = "getRelationshipOrder" output = "false" access = "private" returntype = "struct" hint = "I get the transfer order properties of a relationship">
		<cfargument name="arrColumns" type="array" required="true"  />
		<cfscript>	
			var stOrder 	= structNew();
			var ixCol		= 0;
			var reDateColName	= 'datestamp|[a-zA-Z_\-]*modified[a-zA-Z_\-]*|[a-zA-Z_\-]*updated[a-zA-Z_\-]*|[a-zA-Z_\-]*create[d]?[a-zA-Z_\-]*|[a-zA-Z_\-]*post[ed]?[a-zA-Z_\-]*';
			var reOrderIndexColName	= '[a-zA-Z_\-]*OrderIndex[a-zA-Z_\-]*';
			var reDateType	= '[a-zA-Z]*date[a-zA-Z]*|[a-zA-Z]*time[a-zA-Z]*';
			var columnFound = false; 
			stOrder.success = true;
			stOrder.msg		= 'Relationship order data generated successfully';
			stOrder.results = structNew();
		</cfscript>

		<cftry>
				<cfloop from="1" to="#arrayLen(arguments.arrColumns)#" index="ixCol"> 
					<cfscript>
						if(reFindNoCase( reDateColName,arguments.arrColumns[ixCol].column_name )){
							if(reFindNoCase( reDateType,arguments.arrColumns[ixCol].type_name )){
								stOrder.results.order 	 = 'desc';
								stOrder.results.property = arguments.arrColumns[ixCol].column_name;
								columnFound = true;
								break;
							}
						}else if (reFindNoCase( reOrderIndexColName,arguments.arrColumns[ixCol].column_name )){
								stOrder.results.order 	 = 'asc';
								stOrder.results.property = arguments.arrColumns[ixCol].column_name;
								columnFound = true;
								break;
						}						
					</cfscript>			
				
				</cfloop>
				<cfscript>
					if(not columnFound){
						stOrder.results.order 	 = 'asc';
						stOrder.results.property = arguments.arrColumns[1].column_name;
					}
				</cfscript>
			<cfcatch type = "any">
				
				<cfscript>
					stOrder.success = false;
					stOrder.msg		= 'Error generating Relationship order data';
				</cfscript>
			</cfcatch>
		</cftry>
	
		<cfreturn stOrder />
	</cffunction>
				
		<!---
		******************************************************************************** 
		getPackages()
		Author: Roland Lopez - Date: 8/9/2007 
		Hint: I parsed the packages and put them into an array
		********************************************************************************
		--->
	<cffunction name = "getPackages" output = "false" access = "private" returntype = "array" hint = "I parsed the packages and put them into an array">
		<cfargument name="arrTables" type="array" required="true"  />
		<cfscript>	
			var arrPackages = arrayNew(1);
			var ixTable = 0;
			var tmp = false;
		</cfscript>
	
		<cftry>
			<cfscript>
				for( ixTable=1; ixTable lte arrayLen( arguments.arrTables); ixTable++ ){
					if( not variables.instance.oUdf.arrayFind( arrPackages, getPackageName(arrTables[ixTable].table_name ))){
						arrayAppend( arrPackages,getPackageName(arrTables[ixTable].table_name ));
					}
				}
			</cfscript>		
			<cfcatch type="any">
				<cfdump var="#cfcatch#" label="cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
		<cfreturn arrPackages />
	</cffunction>
	
		<!---
		******************************************************************************** 
		arrangeInPackages()
		Author: Roland Lopez - Date: 8/9/2007 
		Hint: I parse the tables and arrange them in packages.
		********************************************************************************
		--->
	<cffunction name = "arrangeInPackages" output = "false" access = "private" returntype = "boolean" hint = "I parsed the tables and arrange them in packages.">
		<cfargument name="arrTables" type="array" required="true"  />
		<cfargument name="arrPackages" type="array" required="true"  />
		<cfargument name="useUnderscoreNameConvention" type="boolean" required="false"  />
		<cfargument name="useUUIDConvention" type="boolean" required="false"  />
		<cfargument name="generatePrimaryKey" type="boolean" required="false"  />
		<cfargument name="collectionType" type="string" required="false"  />
		<cfargument name="relationshipType" type="string" required="false"  />
		
		<cfscript>	
			var bSuccess = true;
			var ixTable = 0;
			var ixPackage = 0;
			variables.instance.packages = structNew();
				
				//overwrite settings if user has selected them
			
			if(structKeyExists( arguments,'useUUIDConvention' ))
				variables.instance.useUUIDConvention = arguments.useUUIDConvention;
			if(structKeyExists( arguments,'generatePrimaryKey' ))
				variables.instance.generatePrimaryKey= arguments.generatePrimaryKey;
			if(structKeyExists( arguments,'collectionType' ))
				variables.instance.collectionType= arguments.collectionType;
			if(structKeyExists( arguments,'relationshipType' ))
				variables.instance.relationshipType= arguments.relationshipType;
		</cfscript>
		
		<cftry>
			<cfscript>
				for( ixPackage=1; ixPackage lte arrayLen(arguments.arrPackages); ixPackage++ ){
					for( ixTable=1; ixTable lte arrayLen( arguments.arrTables); ixTable++ ){
						if(getPackageName(arrTables[ixTable].table_name ) eq arguments.arrPackages[ixPackage]){
							if(not structKeyExists( variables.instance.packages, getPackageName(arrTables[ixTable].table_name))){
								variables.instance.packages[getPackageName(arrTables[ixTable].table_name)] = arrayNew(1);
							}
							arrayAppend( variables.instance.packages[getPackageName(arrTables[ixTable].table_name)],arrTables[ixTable] );
						}
					}
				}
			</cfscript>	
		
			<cfcatch type="any">
				<cfscript>bsuccess=false;</cfscript>
			</cfcatch>
		</cftry>
		
		<cfreturn bsuccess />
	</cffunction>

		<!---
		******************************************************************************** 
		packagesToXml()
		Author: Roland Lopez - Date: 8/10/2007 
		Hint: I loop through the different packages and convert them to transfer xml format
		********************************************************************************
		--->
	<cffunction name="packagesToXml" output="false" access="private" returntype="boolean" hint="I loop through the different packages and convert them to transfer xml format">
		<cfargument name="relationshipType" type="string" required="false"/>
		
		<cfscript>	
			var success 		= true;
			var ixPackage 		= 0;
			var ixTable			= 0;
			var ixColumn		= 0;
			var ixRelationship 	= 0;
			var currentTable=structNew();
			var nLastCompositeKeyPos = 0;
			var arrRelationships = arrayNew(1);
			var bIsCompositeKeyTable = false;
			variables.instance.xmlPackages = '';	
			
			if(structKeyExists( arguments,'relationshipType' ))
				variables.instance.relationshipType = arguments.relationshipType;
		</cfscript>


		<cftry>
				<cfoutput><cfsavecontent variable="variables.instance.xmlPackages">
				<cfloop collection="#variables.instance.packages#" item="ixPackage">
			<!-- 
			************************
			Package: #ixPackage#  
			************************
			-->
		<package name="#ixPackage#">
					<cfloop from="1" to="#arrayLen(variables.instance.packages[ixPackage])#" index="ixTable">
						<cfset currentTable 	= variables.instance.packages[ixPackage][ixTable] />
						<cfset arrRelationships	=  currentTable.relationships />
			<object name="#getObjectName(currentTable.table_name)#" table="#currentTable.table_name#" >
								<cfset stPrimaryKey	=  getPrimaryKey(currentTable.columns)/>
				<cfset sCompositeKeyColumnList	=  checkCompositeKeyTable(currentTable).list />
				<cfif not listLen(sCompositeKeyColumnList)>
					<cfif StructCount( stPrimaryKey )>
				<id name="#stPrimaryKey.column_name#" type="#getColumnType(stPrimaryKey)#" generate="#variables.instance.oUdf.trueFalseFormat(variables.instance.generatePrimaryKey)#"/>
					<cfelse>
				<!-- No Primary Key Found -->
					</cfif>
				<cfelse>
				<compositeid>
					<cfloop from="1" to="#arrayLen(arrRelationships)#" index="ixRelationship">
						<cfif arrRelationships[ixRelationship].type eq 'manytoone' and listFindNoCase(sCompositeKeyColumnList,arrRelationships[ixRelationship].localColumn)>
					<manytoone name="#arrRelationships[ixRelationship].name#" />
						</cfif>
					</cfloop>
				</compositeid>
				</cfif>
								<cfset arrColumns	=  currentTable.columns />
								<cfloop from="1" to="#arrayLen(arrColumns)#" index="ixColumn">
									<cfif not(arrColumns[ixColumn].is_foreignKey) and not(arrColumns[ixColumn].is_primaryKey)>
				<property name="#arrColumns[ixColumn].column_name#" type="#getColumnType(arrColumns[ixColumn])#" column="#arrColumns[ixColumn].column_name#" nullable="#variables.instance.oUdf.trueFalseFormat(trim(arrColumns[ixColumn].is_nullable))#"/>
									</cfif>
								</cfloop>
								
								<cfloop from="1" to="#arrayLen(arrRelationships)#" index="ixRelationship">
									<cfif arrRelationships[ixRelationship].type neq 'manytomany'>
										<cfif not listFindNoCase(sCompositeKeyColumnList,arrRelationships[ixRelationship].localColumn)>
											<cfset bIsCompositeKeyTable	=  false />
										<cfelse>
											<cfset bIsCompositeKeyTable	=  true />
										</cfif>
									</cfif>
									<cfif arrRelationships[ixRelationship].type eq 'manytoone'>
										<cfif not bIsCompositeKeyTable and variables.instance.relationshipType neq 'manyToOne' >
				<!--</cfif>
				<manytoone name="#arrRelationships[ixRelationship].name#">
					<link to="#arrRelationships[ixRelationship].linkto#" column="#arrRelationships[ixRelationship].linkColumn#"/>
				</manytoone>
											<cfif not bIsCompositeKeyTable and variables.instance.relationshipType neq 'manyToOne' >
				
				--></cfif>
									<cfelseif arrRelationships[ixRelationship].type eq 'onetomany'>
											<cfif bIsCompositeKeyTable or variables.instance.relationshipType neq 'onetomany'>
												
					<!--</cfif>
				<onetomany	name="#arrRelationships[ixRelationship].name#" lazy="true">
				    <link	to="#arrRelationships[ixRelationship].linkTo#"	column="#arrRelationships[ixRelationship].linkColumn#"/>
				    <collection type="#variables.instance.collectionType#">
				     	<order   property="#arrRelationships[ixRelationship].orderProperty#"	order="#arrRelationships[ixRelationship].order#"/>
				    </collection>
				</onetomany>
											<cfif bIsCompositeKeyTable or variables.instance.relationshipType neq 'onetomany'>
				--></cfif>
									<cfelseif arrRelationships[ixRelationship].type eq 'manytomany'>
				<manytomany name="#arrRelationships[ixRelationship].name#" table="#arrRelationships[ixRelationship].table#">
					<link to="#arrRelationships[ixRelationship].linkTo1#" column="#arrRelationships[ixRelationship].linkColumn1#"/>
					<link to="#arrRelationships[ixRelationship].linkTo2#" column="#arrRelationships[ixRelationship].linkColumn2#"/>
					
					<collection type="#variables.instance.collectionType#">
				     	<order   property="#arrRelationships[ixRelationship].orderProperty#"	order="#arrRelationships[ixRelationship].order#"/>
				    </collection>
				</manytomany>	
									</cfif>
								</cfloop>
			</object>
					</cfloop>
		</package>
				</cfloop>
				</cfsavecontent>
				</cfoutput>
				
			<cfcatch type="any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfdump var = "#currentTable#" label = "currentTable" />
				<cfabort />
				<cfscript>
					success = false;
				</cfscript>
			</cfcatch>
		</cftry>
	
		<cfreturn success />
	</cffunction>
	
		<!---
		******************************************************************************** 
		checkCompositeKeyTable()
		Author: Roland Lopez - Date: 9/7/2007 
		Hint: 
		********************************************************************************
		--->
	<cffunction name="checkCompositeKeyTable" output="false" access="private" returntype="struct" hint="">
		<cfargument name="stTable" type="struct" required="true"  />
		<cfscript>	
			var aCols 		= arrayNew(1);
			var ixCol 		= 1;
			var ixCompKey 	= 1;
			var stCompositeKeyColumn = structNew();
			stCompositeKeyColumn.nPkCount = 0;
			stCompositeKeyColumn.list = '';
		</cfscript>
		<cftry>
			<cfscript>
				if (arrayLen(arguments.stTable.columns) gt 2){
					aCols = arguments.stTable.columns;
					
					for( ixCol; ixCol lte arrayLen(aCols); ixCol++){
						if (aCols[ixCol].is_foreignKey and aCols[ixCol].is_primaryKey){
							stCompositeKeyColumn.list = listAppend(stCompositeKeyColumn.list,aCols[ixCol].column_name);
							stCompositeKeyColumn.nPkCount++;
						}
					}
					if( stCompositeKeyColumn.nPkCount lte 1 or arrayLen(arguments.stTable.columns) eq stCompositeKeyColumn.nPkCount){
						stCompositeKeyColumn.list = '';
					}
				}
			</cfscript>
						
			<cfcatch type="any">
				<cfdump var = "#cfcatch#" label = "cfcatch" />
				<cfabort />
			</cfcatch>
		</cftry>
	
		<cfreturn stCompositeKeyColumn />
	</cffunction>

	<cffunction name="resetOneToManyRelationships">
		<cfscript>
			variables.instance.aOneToManyRelationships = arrayNew(1);
		</cfscript>
	</cffunction>

		<!--- setdsn(string) --->
	<cffunction name="setdsn" access="public" returntype="void" hint="I set dsn variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.instance.dsn = arguments.value />
	</cffunction>
	
		<!--- getdsn() --->
	<cffunction name="getdsn" access="public" returntype="string" hint="I get dsn variable" output="false">
		<cfreturn variables.instance.dsn  />
	</cffunction>

		<!--- setconfigPath(string) --->
	<cffunction name="setconfigPath" access="public" returntype="void" hint="I set configPath variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.instance.configPath = arguments.value />
	</cffunction>
	
		<!--- getconfigPath() --->
	<cffunction name="getconfigPath" access="public" returntype="string" hint="I get configPath variable" output="false">
		<cfreturn variables.instance.configPath  />
	</cffunction>
	
		<!--- setuseNameConvention(boolean) --->
	<cffunction name="setuseNameConvention" access="public" returntype="void" hint="I set useNameConvention variable" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset variables.instance.useNameConvention = arguments.value />
	</cffunction>
	
		<!--- getuseNameConvention() --->
	<cffunction name="getuseNameConvention" access="public" returntype="boolean" hint="I get useNameConvention variable" output="false">
		<cfreturn variables.instance.useNameConvention  />
	</cffunction>
	
		<!--- setuseUUIDConvention(boolean) --->
	<cffunction name="setuseUUIDConvention" access="public" returntype="void" hint="I set useUUIDConvention variable" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset variables.instance.useUUIDConvention = arguments.value />
	</cffunction>
	
		<!--- getuseUUIDConvention() --->
	<cffunction name="getuseUUIDConvention" access="public" returntype="boolean" hint="I get useUUIDConvention variable" output="false">
		<cfreturn variables.instance.useUUIDConvention  />
	</cffunction>
	
		<!--- setgeneratePrimaryKey(boolean) --->
	<cffunction name="setgeneratePrimaryKey" access="public" returntype="void" hint="I set generatePrimaryKey variable" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset variables.instance.generatePrimaryKey = arguments.value />
	</cffunction>
	
		<!--- getgeneratePrimaryKey() --->
	<cffunction name="getgeneratePrimaryKey" access="public" returntype="boolean" hint="I get generatePrimaryKey variable" output="false">
		<cfreturn variables.instance.generatePrimaryKey  />
	</cffunction>

		<!--- setcollectionType(string) --->
	<cffunction name="setcollectionType" access="public" returntype="void" hint="I set collectionType variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.instance.collectionType = arguments.value />
	</cffunction>
	
		<!--- getcollectionType() --->
	<cffunction name="getcollectionType" access="public" returntype="string" hint="I get collectionType variable" output="false">
		<cfreturn variables.instance.collectionType  />
	</cffunction>	

		<!--- setrelationshipType(any) --->
	<cffunction name="setrelationshipType" access="public" returntype="void" hint="I set relationshipType variable" output="false">
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.relationshipType = arguments.value />
	</cffunction>
	
		<!--- getrelationshipType() --->
	<cffunction name="getrelationshipType" access="public" returntype="any" hint="I get relationshipType variable" output="false">
		<cfreturn variables.instance.relationshipType  />
	</cffunction>	
	
		<!--- setOUdf(any) --->
	<cffunction name="setOUdf" access="public" returntype="void" hint="I set OUdf variable" output="false">
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.OUdf = arguments.value />
	</cffunction>
	
		<!--- getOUdf() --->
	<cffunction name="getOUdf" access="public" returntype="models.Udf" hint="I get OUdf variable" output="false">
		<cfreturn variables.instance.OUdf  />
	</cffunction>
	
		<!--- setdefaultFileName(string) --->
	<cffunction name="setdefaultFileName" access="public" returntype="void" hint="I set defaultFileName variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.instance.defaultFileName = arguments.value />
	</cffunction>
	
		<!--- getdefaultFileName() --->
	<cffunction name="getdefaultFileName" access="public" returntype="string" hint="I get defaultFileName variable" output="false">
		<cfreturn variables.instance.defaultFileName  />
	</cffunction>
</cfcomponent>