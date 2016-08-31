	<!---
	*****************************************************
	Name: 			vwGenerateConfig.cfm
	Description:	
	Author:			roland.lopez
	Date:			9/13/2007
	
	License: 		This work is licensed under the Creative Commons Attribution-Share Alike 3.0 License. 
					To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ 
					or send a letter to Creative Commons, 171 Second Street, Suite 300, San Francisco, 
					California, 94105, USA.	
	*****************************************************
	--->


<style type = "text/css">
	table{
		font-size:12px;
		font-family:arial;
		border: 1px solid gray;
		
	}

</style>
<cfoutput>
<form name="frmGenerateConfig" method="post">
	<table border="0" width="800" cellpadding="0" cellspacing="0">
		<tr>
			<th colspan="2" style="background-color:##3F3F3F;color: ##fff;height:25px;">
				Config Settings
			</th>
		</tr>
		<tr>
			<th style="width:200px;">
				DSN:
			</th>
			<td>
				<cfif structCount(stDataSources) gt 0>
					<select name="dsn">
						<cfloop collection="#stDataSources#" item="ixDataSource">
							<option value="#ixDataSource#" #iif(form.dsn eq ixDataSource,DE('Selected'),DE(''))#>#ixDataSource#</option>
						</cfloop>
					</select>
				<cfelse>
					<input type="text" name="dsn" value="#form.dsn#" onFocus="this.select();" />
				</cfif>
			</td>
		</tr>
		<tr>
			<th style="width:200px;">
				Use under_score convention:
			</th>
			<td>
				<input type="radio" value="true" name="useUnderscoreNameConvention" id="underScoreYes" #iif(form.useUnderscoreNameConvention,DE('checked'),DE(''))#/><label for="underScoreYes">Yes</label>
				<input type="radio" value="false" name="useUnderscoreNameConvention" id="underScoreNo" #iif(form.useUnderscoreNameConvention,DE(''),DE('checked'))# /><label for="underScoreNo">No</label>
			</td>
		</tr>
		<tr>
			<th >
				Use UUID Convention:
			</th>
			<td>
				<input type="radio" value="true" name="useUUIDConvention" id="uuidConventionYes" #iif(form.useUUIDConvention,DE('checked'),DE(''))#/><label for="uuidConventionYes">Yes</label>
				<input type="radio" value="false" name="useUUIDConvention" id="uuidConventionNo" #iif(form.useUUIDConvention,DE(''),DE('checked'))#/><label for="uuidConventionNo">No</label>
			</td>
		</tr>
		<tr>
			<th >
				Generate PK:
			</th>
			<td>
				<input type="radio" value="true" name="generatePrimaryKey" id="generatePrimaryKeyYes" #iif(form.generatePrimaryKey,DE('checked'),DE(''))#/><label for="generatePrimaryKeyYes">Yes</label>
				<input type="radio" value="false" name="generatePrimaryKey" id="generatePrimaryKeyNo"  #iif(form.generatePrimaryKey,DE(''),DE('checked'))#/><label for="generatePrimaryKeyNo">No</label>
			</td>
		</tr>
		<tr>
			<th >
				Collection Type:
			</th>
			<td>
				<select name="collectionType">
					<option value="array" #iif(form.collectionType eq 'array',DE('Selected'),DE(''))#>Array</option>
					<option value="struct" #iif(form.collectionType eq 'struct',DE('Selected'),DE(''))#>Structure</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<th >
				Relationship Type to Use:
			</th>
				
			<td>
				<input type="radio" value="onetomany" name="relationshipType" id="relationshipTypeOTM" #iif(form.relationshipType eq 'onetomany',DE('checked'),DE(''))#/><label for="relationshipTypeOTM">One-to-Many</label>
				<input type="radio" value="manytoone" name="relationshipType" id="relationshipTypeMTO"  #iif(form.relationshipType eq 'manytoone',DE('checked'),DE(''))#/><label for="relationshipTypeMTO">Many-to-One</label>
			</td>
		</tr>
		<tr>
			<th >
				File Name:
			</th>
			<td>
				<input type="text" name="fullFileName" value="#form.fullFileName#" onFocus="this.select();">
			</td>
		</tr>
		<tr >
			<td align="left" >
				<input type="button" name="btnViewXml" onclick="submitForm(this)" value="View XML"/>
			</td>
			<td align="right">
				<input type="button" name="btnGenerateFile" onclick="submitForm(this)" value="Genarate Config File"/>
			</td>
		</tr>
	</table>		
</form>
</cfoutput>
<script language = "javascript" type = "text/javascript">
	function submitForm( btn ){
		var theForm = document.frmGenerateConfig;
		switch(btn.name){
			case 'btnViewXml':
				theForm.action = 'index.cfm?event=transferConfig.xml';
			break;
			case 'btnGenerateFile':
				theForm.action = 'index.cfm?event=transferConfig.writeXml';
			break;
		}
		theForm.submit();
	}
</script>
