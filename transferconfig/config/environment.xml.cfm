<?xml version="1.0" encoding="UTF-8"?>
<environments>
	<default>
        <config>
				<!-- main vars -->
			<property name="dsn"><!--your default dsn goes here--></property>
			<property name="configPath">/config</property>
			<property name="useUnderscoreNameConvention">false</property>
			<property name="useUUIDConvention">true</property>
			<property name="generatePrimaryKey">true</property>
			<property name="collectionType">array</property>
			<property name="relationshipType">oneToMany</property>
			<property name="defaultFileName">transferX.xml</property>
			<property name="viewsPath">/views</property>
			<property name="objRootPath"></property>
			<property name="rootPath"></property>
			<property name="cfAdminPwd"></property><!-- This is used to list your DSN's as a 
															   dropdown in the generate transfer file form.
															   If no valid pwd is provided then a text field will
															   be used instead. -->
        </config>
	</default>
	<environment id="site1">
        <patterns>
            <pattern>^site1.com</pattern>
        </patterns>
        <config><!-- variables here and its values will only affect the site specified on the pattern tag.  
					A variable declared in the default environment will exists on all environments and its default
					value will be used unless such variable
					is explicitly overwritten here. -->
			<property name="dsn">site1DsnName</property>+
			<property name="useUUIDConvention">false</property>
		</config>
	</environment>
	<environment id="site2">
        <patterns>
            <pattern>^site2.com</pattern>
            <pattern>^site2.org</pattern> <!-- multiple patters can be added -->
			
        </patterns>
        <config>
			<property name="dsn">site2DsnName</property>
			<property name="collectionType">struct</property>
        </config>
	</environment>
		<!-- a catch all environment must exist (but you can name it as you please).  
			This mainly use for production environments where you might have multiple domains
			and don't want to have to add a new pattern for each domain. --> 
	<environment id="catchAll">
        <patterns>
            <pattern>.*</pattern>
        </patterns>
        <config>
			
        </config>
	</environment>
</environments>		