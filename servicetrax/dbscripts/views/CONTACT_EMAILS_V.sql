CREATE VIEW dbo.CONTACT_EMAILS_V
AS
SELECT     dbo.CONTACTS.CONTACT_ID, dbo.CONTACTS.CONTACT_NAME, dbo.CONTACTS.CONT_STATUS_TYPE_ID, dbo.LOOKUPS.NAME AS Status, 
                      dbo.CONTACTS.EMAIL
FROM         dbo.CONTACTS INNER JOIN
                      dbo.LOOKUPS ON dbo.CONTACTS.CONT_STATUS_TYPE_ID = dbo.LOOKUPS.LOOKUP_ID
WHERE     (dbo.CONTACTS.CONT_STATUS_TYPE_ID = 128) AND (dbo.CONTACTS.EMAIL IS NOT NULL)
