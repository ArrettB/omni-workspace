set TOMCAT_HOME=c:\jakarta-tomcat-3.2.2
set JAVA_HOME=c:\jdk1.3.1

net stop Tomcat
start c:\Dynamics\Dynamics.exe c:\Dynamics\Dynamics.set c:\Dynamics\Login.mac
c:\jakarta-tomcat-3.2.2\bin\tomcat.bat start