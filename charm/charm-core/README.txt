This is the read me file for Charm and should contain the changes made to the different
versions.


Changes for Version 0.7
=======================

rbvh - changed behavior of the file upload in the FormController so that when a file is not
actually selected for upload, the UploadedFile object is not put into the request
attribute ArrayList under the name Constants.UPLOADED_FILES.
So, if no files are uploaded, the ArrayList will have a length of 0.

rbvh - fixed the pom so that xdoclet works with Maven 2.0.7

rbvh - Added the getRawMessage() methods to support displaying the Default error message
if it is supplied in form tags.

rbvh - fixed handling for some query service calls which were failing because they had no
default data server.


Changes for Version 0.8
=======================

rbvh - changed the behavior for charm:form to redirect on successful submission and optionally
pass parameters.


Changes for Version 0.9
=======================

rbvh,jc - fixes parent problems


Changes for Version 1.0
=======================

jh - added AjaxTag

rbvh - Updated the Calendar and Date tags to support customization.


Changes for Version 1.1
=======================

rbvh - Added com.dynamic.charm.web.form.controller.PrePostProcessor 

rbvh - Added com.dynamic.charm.web.form.controller.PrePostHibernateProcessor 

rbvh,jc - Added charm form bound field forward as parameter functionality 


Changes for Version 1.2
=======================

rbvh - Charm-parent update to 2.1 for library updates
	log4j 1.2.13 -> 1.2.15
	javax.mail 1.3.2 -> 1.4.1
	javax.activation 1.0.2 -> 1.1.1
	commons-beanutils 1.7.0 -> 1.8.0
	commons-collections 3.1 -> 3.2
	commons-digester 1.7 -> 1.8.1
	commons-io 1.1 -> 1.3
	commons-lang 2.1 -> 2.4
	commons-fileupload 1.2 -> 1.2.1
	spring-mock 2.0.6 -> 2.0.8

rbvh - Updated AbstractProcessor to remove deprecated call.


Changes for Version 1.3
=======================

rbvh - updated the charm form select and ajax tags to redisplay the
selected value after an error.


Changes for Version 1.4
=======================

rbvh - fixed meta site generation.

rbvh - Added bean loading from the JDBC Service

rbvh - Updated to charm-parent 2.2 which updates the Spring core libraries from 2.0.8 -> 2.5.6



 
