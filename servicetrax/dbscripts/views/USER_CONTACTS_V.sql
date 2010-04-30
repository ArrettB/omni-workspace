CREATE VIEW dbo.USER_CONTACTS_V
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.ACTIVE_FLAG, dbo.CONTACTS.EMAIL, 
                      dbo.CONTACTS.ORGANIZATION_ID
FROM         dbo.USERS INNER JOIN
                      dbo.CONTACTS ON dbo.USERS.CONTACT_ID = dbo.CONTACTS.CONTACT_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'y') AND (dbo.CONTACTS.EMAIL IS NOT NULL)
