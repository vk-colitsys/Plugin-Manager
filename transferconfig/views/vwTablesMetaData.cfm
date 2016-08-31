<style type = "text/css">
	table{
		font-size:12px;
		font-family:arial;
	}
	th{
		text-align:left;
		background-color:#3F3F3F;
		color: #fff;
	}
	table#columns{
		border: 1px solid gray;
	}
</style>

<!--- <cfdump var = "#variables.tablesMetaData.results#" label = "variables.tablesMetaData" /> ---> 
<cfoutput>
<cfloop from="1" to="#arrayLen(aTables)#" index="ixTable">


	<table border="0" width="800" cellpadding="0" cellspacing="0">
		<tr>
			<th style="width:50px;">
				#aTables[ixTable].TABLE_TYPE#:
			</th>
			<td style="padding-left:15px;font-weight:bold;">
				#aTables[ixTable].table_name#
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table border="0" width="100%" cellpadding="4" cellspacing="0" id="columns">
					<tr>
						<th>
							PK
						</th>
						<th>
							Column
						</th>
						<th>
							Type
						</th>
						<th>
							Null
						</th>
						<th>
							Default
						</th>
						<th>
							Octect Len
						</th>
						<th>
							Dec
						</th>
						<th>
							FK
						</th>
						<th>
							Ref FK
						</th>
						<th>
							Ref. FK Table
						</th>
					</tr>
				
	<cfset aColumns	= aTables[ixTable].columns />
	<cfloop from="1" to="#arrayLen(aColumns)#" index="ixColumn">
					<tr>
						<td>
							#aColumns[ixColumn].is_primarykey#
						</td>
						<td>
							#aColumns[ixColumn].column_name#
						</td>
						<td>
							#aColumns[ixColumn].type_name#(#aColumns[ixColumn].column_size#)
						</td>
						<td>
							#aColumns[ixColumn].is_nullable#
						</td>
						<td>
							#aColumns[ixColumn].column_default_value#
						</td>
						<td>
							#aColumns[ixColumn].char_octet_length#
						</td>
						<td>
							#aColumns[ixColumn].decimal_digits#
						</td>
						<td>
							#aColumns[ixColumn].is_foreignkey#
						</td>
						<td>
							#aColumns[ixColumn].referenced_primarykey#
						</td>
						<td>
							#aColumns[ixColumn].referenced_primarykey_table#
						</td>
					</tr>
	</cfloop>
				</table>		
			</td>
		</tr>
	</table>
	<br /><br />		
</cfloop>
</cfoutput>