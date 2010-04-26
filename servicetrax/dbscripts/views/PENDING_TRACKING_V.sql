CREATE VIEW dbo.PENDING_TRACKING_V
AS
SELECT     
	'service' type, 
	t .TRACKING_ID, 
	t .NOTES, 
	ISNULL(CONVERT(varchar, s.SERVICE_NO), 'N') AS record_no, 
	j.JOB_NO,
	ISNULL(j.JOB_NAME, 'N/A') AS job_name, 
	CONVERT(varchar, t .DATE_CREATED) AS date_created, 
	Tracking_type.ATTRIBUTE1, 
	c.contact_id,
	c.contact_name, 
	c.EMAIL as to_email,
	t .EMAIL_SENT_FLAG,
	CONTACTS_1.EMAIL AS from_email
FROM          dbo.TRACKING t LEFT OUTER JOIN
                      dbo.CONTACTS c ON t .TO_CONTACT_ID = c.CONTACT_ID RIGHT OUTER JOIN
                      dbo.USERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.USERS.CONTACT_ID = CONTACTS_1.CONTACT_ID ON 
                      t .FROM_USER_ID = dbo.USERS.USER_ID LEFT OUTER JOIN
                      dbo.LOOKUPS Tracking_type ON t .TRACKING_TYPE_ID = Tracking_type.LOOKUP_ID LEFT OUTER JOIN
                      dbo.JOBS j ON t .JOB_ID = j.JOB_ID LEFT OUTER JOIN
                      dbo.SERVICES s ON t .SERVICE_ID = s.SERVICE_ID
WHERE     (Tracking_type.ATTRIBUTE1 = 'SEND_EMAIL') AND (t .EMAIL_SENT_FLAG= 'N')
UNION ALL
SELECT     
   'invoice' AS type, 
   t.INVOICE_TRACKING_ID AS TRACKING_ID, 
   t.NOTES, 
   ISNULL(CONVERT(varchar, i.INVOICE_ID), 'N') AS record_no, 
   j.JOB_NO, 
   ISNULL(j.JOB_NAME, 'N/A') AS job_name,
   CONVERT(varchar, t.DATE_CREATED) AS date_created,
   Tracking_type.ATTRIBUTE1, 
   c.CONTACT_ID, 
   c.CONTACT_NAME, 
   c.EMAIL AS to_email, 
   t.EMAIL_SENT_FLAG, 
   CONTACTS_1.EMAIL AS from_email
FROM         dbo.USERS LEFT OUTER JOIN
                      dbo.CONTACTS CONTACTS_1 ON dbo.USERS.CONTACT_ID = CONTACTS_1.CONTACT_ID RIGHT OUTER JOIN
                      dbo.JOBS j RIGHT OUTER JOIN
                      dbo.CONTACTS c RIGHT OUTER JOIN
                      dbo.INVOICE_TRACKING t LEFT OUTER JOIN
                      dbo.LOOKUPS Tracking_type ON t.INVOICE_TRACKING_TYPE_ID = Tracking_type.LOOKUP_ID ON c.CONTACT_ID = t.TO_CONTACT_ID LEFT OUTER JOIN
                      dbo.INVOICES i ON t.INVOICE_ID = i.INVOICE_ID ON j.JOB_ID = i.JOB_ID ON dbo.USERS.USER_ID = t.FROM_USER_ID
WHERE     (Tracking_type.ATTRIBUTE1 = 'SEND_EMAIL') AND (t.EMAIL_SENT_FLAG = 'N')






