$Id: readme.txt 1689 2009-10-16 14:34:55Z bvonhaden $

A&M projects Readme
===================

Scott Anderson
scanderson@ambis.com
612-627-1650

Jerry Chrisman
ChrismanJ@omniworkspace.com
612-627-1655

Project name in Subversion: servicetrax
Project name in Jira: ANM


There are two A&M projects contained within this directory structure

- ims which is an iFrame2 application
- stc which is a Charm application

The two applications are released as a set.


The build consists of a Maven script and an ANT script.
You will want to have the \work\common\3rd Party Update folder up to date.
cd \work\common\3rd Party Update and type "ant". to refresh the shared libraries.


Then the steps for the release lifecycle are to do the following steps when you want to
deploy a release to A&M.

Configuration Info:
===================
production Web server:
        deployemnt dir: E:\Program Files\Apache Software Foundation\Tomcat 5.5\webapps
	JDK version: 1.5.0_11
	MS Excel version: 2003
	Tomcat version: 5.5.17 (recommend using 5.5.25+)
	Windows Server version: 2003 SP 1

production DB server:
	SQL server version: 2000
	Windows Server version: 2003 SP 1

RELEASE BUILD:
==============

1. In Jira, create the next Fix Version
2. Assign the Jira issues to that Version
3. Create the Release Notes
4. Put the release notes file in the FTP directory \\honda\ftp\ambis named with the version information.
	e.g. \\honda\ftp\abmis\1.25
5. Update version entry in the ims.Version file.
6. Go to the staging folder to avoid workspace contamination
	cd \stage\servicetrax
7. Do a clean checkout of the code
	svn update
8. Validate the application is ready to build and create the build tags in subversion
	mvn -Pprod release:prepare
9. Generate the release
	mvn -Pprod release:perform
10. Check out the created release tag
11. Build the deployment
	ant
12. copy the war files from the build folder to the FTP directory.
	ims-sourcesNNNN.jar
	stc-sourcesNNNN.jar
	ims-prodNNNN.war
	stc-prodNNNN.war
	ims-qaNNNN.war
	stc-qaNNNN.war
13. copy any sql scripts from the dbscripts folder to the FTP directory.

When necessary to modify the released version, create an SVN branch for the production build and name it something like:
	Release_1.25



The deployments are made available to A&M on the FTP server ftp.apexit.com.
The war files from servicetrax\build are copied to the FTP server deployment directory in a subdirectory
named by the version.  So if the deployment is for version 1.20, the FTP folder is named 1.20.

Jerry Chrisman is notified of the deployment availability and he will download and deploy the applications from
ftp.apexit.com username="ambis".



Development setup
==================


The build environment should be set for Java JDK 1.5 with Maven 2.0.9.


To set up Eclipse
--------------------
cd \work\servicectrax\ims
mvn eclipse:eclipse

cd \work\servicectrax\stc
mvn eclipse:eclipse


To deploy for Tomcat
--------------------
cd \work\servicectrax\ims
mvn clean compile war:inplace

cd \work\servicectrax\stc
mvn clean compile war:inplace


SVN setup
--------------------
svn ignore the following
/target
/work
/src/main/webapp/WEB-INF/lib
/src/main/webapp/WEB-INF/classes


Tomcat
--------------------
Add the following line in the server.xml file for deploying with Eclipse Tomcat plugin.
<Context path="/stc" reloadable="true" docBase="C:\work\serviceTrax\stc\src\main\webapp" workDir="C:\work\serviceTrax\stc\work" />



Test and Production Access
==========================

There is a Citrix VPN set up to access the Test and Production servers.

https://partners.hnicorp.com
The account is: zhaod/omni1234  -> zz923omn1
Use the ENTRUST card for the challenge code.

Use the Citrix remote desktop to reach the following machines:

Production
----------
web=172.17.17.240  SRV-DMZ-INET8
db=172.17.17.239  MPSOMN-SQLDB01P

h:\mssql\backups

QA
----------
web=172.17.17.245  SRV-OMNI-WEB02
db=172.17.17.92  SRV-DMZ-SQL7

