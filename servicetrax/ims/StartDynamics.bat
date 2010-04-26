rem stop the Tomcat service
net stop Tomcat

rem start GP Dynamics using the login.mac
start e:\Dynamics\Dynamics.exe e:\Dynamics\Dynamics.set e:\Dynamics\Login.mac

rem set the environment for tomcat
set TOMCAT_HOME=e:\jakarta-tomcat-3.2.2
set JAVA_HOME=e:\jdk1.3.1

rem start tomcat though the command line
e:\jakarta-tomcat-3.2.2\bin\tomcat.bat start