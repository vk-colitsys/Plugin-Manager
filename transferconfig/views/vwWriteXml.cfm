<style type = "text/css">
	th{ text-align:left; }
</style>
<cfoutput>
<div>
	<table border="0" width="700" cellpadding="0" cellspacing="0">
		<tr>
			<th>
				Status
			</th>
			<td>
				#iif(tablesMetadata.success,DE("Successful"),DE("Failed"))#
			</td>
		</tr>
		<tr>
			<th>
				Message:
			</th>
			<td>
				#tablesMetaData.msg#
			</td>
		</tr>
		<tr>
			<th>
				Destination:
			</th>
			<td>
				#tablesMetaData.writtenTo#
			</td>
		</tr>
	</table>		

</div>
</cfoutput>