# omni-workspace
This thing is currently configured to run on maven 2.2.0. With a mac, chances are there's a maven install in /usr/share/maven, 
but check the version (from the command line: mvn -version)

The way this gets wired together depends on the maven profile you are running. For example, with the dev profile, the 
ims pom will copy the web-dev.xml file to a new web.xml file to be packaged in the ims.war. The ims pom also copies ims-dev.xml to a file named ims.xml, which is the main configuration file for the iFrame BaseServlet. This is set via the element of web.xml.

Assuming you are running the maven dev profile, you need to configure the locations of the projectDir and the htmlDir in your ims-dev.xml file. For example:
You also need to configure the sqlserver element of the in the ims-dev.xml. An example:
<resource name="sqlserver" id="//rolla.kettleriverconsulting.com:1433/IMS_NEW;appName=ServiceTrax" username="ims" password="ims" type="SharedPool" default="true"/>

For some operations, you also need to configure the sqlserver_gp element of the in the ims-dev.xml. An example:
<resource name="sqlserver_gp" id="//rolla.kettleriverconsulting.com:1433/AMBIM" username="ims" password="ims" type="SharedPool" default="false"/>

You also need to configure the location of your ims.xml file in the web-dev.xml file. Right now, this is 
(unfortunately) a fully-qualified path:
<init-param>
  <param-name>
    iniFile
  </param-name>
  <param-value>
    /Users/pgarvie/projects/omni/servicetrax/ims/src/main/webapp/WEB-INF/ims.xml
  </param-value>
</init-param>

For stc, you also need to make sure that the database settings in servicetrax/stc/src/main/resources/hibernate.cfg.xml 
are correct. The way this seems to work is you start with the stc pom.xml element which designates the specific 
-filter.properties file to use (e.g., dev-filter.properties). Most of the values in this property file are 
propagated to both hibernate.cfg.xml and to an application.properties file, which is used by the propertyConfigurer 
in the applicationContext.xml files. 

On the other hand, not all of the -filter.properties file appear to be carried over. For example, the hibernate.dialect 
and hibernate.connection.driver_class properties in hibernate.cfg.xml are not, for some reason, so you may have to modify 
these directly. 

There is also a -filter.properties file for ims, but it doesn't appear as if the application uses this, but who knows?
The app has two war files, ims.war and stc.war. To generate these, run the install target of the maven Omni Parent project.
Assuming this runs successfully, this will generate the war files, which should be in the servicetrax/ims/target/ and 
servicetrax/stc/target/ directories. 

Stop Tomcat, copy these to the webapps directory of your Tomcat install, then restart. Assuming all goes well, once the 
server starts, point your browser to http://localhost:8080/ims/action/login.html and you should see the login screen. 

Alternatively, do this
To drop, recreate and populate the database with the initialization data, run the rebuildDbAndLoadConfigData target of the /data/config.xml ant script. The data that gets loaded will (amongst other things) create a user with the admin role, username/pass: kriver/kriver with a pin of 1234:
ant -f config.xml rebuildDbAndLoadConfigData
Additional dataset files need to be added to the dbunit target as an additional
