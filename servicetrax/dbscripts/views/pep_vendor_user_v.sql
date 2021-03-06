CREATE VIEW dbo.pep_vendor_user_v
AS
SELECT     TOP 100 PERCENT dbo.USERS.LAST_NAME, dbo.USERS.FULL_NAME, dbo.USERS.CUSTOMER_ID, dbo.USERS.VENDOR_CONTACT_ID, 
                      dbo.CUSTOMERS.CUSTOMER_NAME
FROM         dbo.USERS INNER JOIN
                      dbo.CUSTOMERS ON dbo.USERS.CUSTOMER_ID = dbo.CUSTOMERS.CUSTOMER_ID
ORDER BY dbo.USERS.LAST_NAME

