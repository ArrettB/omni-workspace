@echo off
SET jarDir=C:\work\ims\www\jar

SET classes=%classes%;%jarDir%\iFrame2.jar
SET classes=%classes%;%jarDir%\parser.jar
SET classes=%classes%;%jarDir%\jaxp.jar
SET classes=%classes%;%jarDir%\oroinc.jar
SET classes=%classes%;%jarDir%\classes12.zip
SET classes=%classes%;%jarDir%\Opta2000.jar

echo Starting webserver...
C:\javawebserver2.0\bin\httpdnojre -cp %classes% -javahome C:\jdk1.2.2 -vmargs -mx64M -Djava.compiler=NONE 

