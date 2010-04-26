$Id: readme.txt 1646 2009-07-27 21:17:06Z bvonhaden $

The IMS project is for A&M Business Interior Services (AMBIS), otherwise known as 
Omni Workspace Manufacturing.

Main contacts at A&M are Scott Anderson (domain knowledge) and Jerry Chrisman (tech).


The site is hosted by A&M on the URL http://www.servicetrax.org/ims/action/login.html.
The project uses Microsoft SQL Server for database storage.
The project is deployed on Microsoft IIS in the Apache Tomcat 5.5 servlet container
via ISAPI on a Microsoft Windows Server 2003.
The Java JDK is 1.5.0_11-b03.


The project is stored in the Subversion archive "servicetrax" as an element of a two
servlet deployment, one is "ims" and the other is "stc".  The IMS project is a custom
iFrame2 application for which the iFrame2 source code is lost.
The STC project is based on Charm.

The URL to launch the IMS application is:
	http://localhost/ims/action/login.html

The STC application is called from specific pages within the IMS application and is not
meant to be called directly because STC uses a handshake from the IMS side for validation.

There is a test server on http://ims.apexit.com/ims/action/login.html hosted on 
MS Windows 2003 in a a VMWare server and may be accessed via remote desktop
to ims.apexit.com.  The login is administrator/apex.
You may access the admin file share directly by using the IP address,
	e.g. \\10.173.12.166\c$

The main Tomcat folder is Program Files\Apache Software Foundation\Tomcat 5.5 which shows up 
in the Windows Services as "Apache Tomcat 1".
There is also an archive Tomcat instance Program Files\Apache Software Foundation1\Tomcat 5.5
which shows up in the Windows Services as "Apache Tomcat 2".




To build for the Development environment.

1. from the ims folder in the main project directory.
2. type
	mvn compile war:inplace
3. refresh your eclipse project.


To build just the ims.war for the test environment on ims.apexit.com

1. from the ims folder in the main project directory.
2. type
	mvn clean package -Ptest
3. copy the file C:\work\servicetrax\ims\target\ims.war to the ims.apexit.com folder
	C:\Program Files\Apache Software Foundation\Tomcat 5.5\webapps


To build just the ims.war for QA deployment to the QA Test server at A&M.

1. from the ims folder in the main project directory.
2. type
	mvn clean package -Pqa


To build just the ims.war for production deployment to the production server at A&M.

1. from the ims folder in the main project directory.
2. type
	mvn clean package -Pprod


To build both the ims.war and stc.war for test, qa, and prod, go to the main project
directory and type ant.  This will create ims-test.war, ims-qa.war, ims-prod.war
and ims-sources.jar, as well as the relavent stc versions.


============================
Setup
============================
This application uses an XLS file manipulator called JCOM.

Extract "jcom222.zip". And copy jcom.dll to the following directories

jcom.dll -> (java.home)/bin/

make sure the JAVA_HOME evironmental variable has been set, ie.
(java.home) == java.lang.System.getProperty("java.home");



******************************
Updating the iFrame SQL parser
******************************

The iFrame SQL query parser is generated from a JavaCC grammar file sql.jj.
This source file is compiled with the JavaCC (Java Compiler Compiler) using the command below.
JavaCC is a standalone application and may be downloaded from https://javacc.dev.java.net/.

C:\work\servicetrax\ims>c:\dev\javacc-4.0\bin\javacc.bat -OUTPUT_DIRECTORY:"c:\work\servicetrax\ims\src\main\java\dynamic\dbtk\parser" c:\work\servicetrax\ims\src\main\java\dynamic\dbtk\parser\sql.jj
Java Compiler Compiler Version 4.0 (Parser Generator)
(type "javacc" with no arguments for help)
Reading from file c:\work\servicetrax\ims\src\main\java\dynamic\dbtk\parser\sql.jj . . .
File "TokenMgrError.java" does not exist.  Will create one.
File "ParseException.java" does not exist.  Will create one.
File "Token.java" does not exist.  Will create one.
File "SimpleCharStream.java" does not exist.  Will create one.
Parser generated successfully.


*************************************************
Deploying updated iFrame to the Maven Repository
*************************************************

ServiceTrax uses Maven to manage the java libraries.  The iFrame2.jar file for ServiceTrax is a lost
code application which means we no longer can build the jar file from source.  Any modifications
to the jar file are done manually by decompiling the old .class files into Java source files, and moving
the source into the IMS project, and removing the old .class file from the iFrame2.jar file.

In order to use the updated iFrame2.jar file, it needs to be deployed to the Maven repository.
This is done by putting the iFrame2.jar file in the ims\3rdparty-libs with the appropriately incremented
version information.  The iFrame2 section in the ims\3rdparty-lib\build.xml file will need to be updated
to reflect the new version information.

1. Update the iFrame2.jar file.
2. Put the updated iFrame2.jar file in the ims\3rdparty-lib with the appropriate name, i.e. iFrame2-ims-1.2.jar
3. Update the ims\3rdparty-lib\build.xml for the new version information
4. from the command line in the ims\3rdparty-lib folder, run
	ant deploy_iframe
5. Check in the updated files in the ims\3rdparty-lib folder, including the build.xml file and the new iFrame2.jar file.
6. Update the ims\pom.xml file to refelct the new iFrame2 version.


