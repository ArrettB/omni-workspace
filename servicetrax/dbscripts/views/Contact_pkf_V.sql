CREATE VIEW dbo.Contact_pkf_V
AS
SELECT     CONTACT_ID, CONTACT_NAME, CUSTOMER_ID, CONTACT_TYPE_ID
FROM         dbo.CONTACTS
WHERE     (CUSTOMER_ID IS NULL) AND (CONTACT_TYPE_ID = 137)

