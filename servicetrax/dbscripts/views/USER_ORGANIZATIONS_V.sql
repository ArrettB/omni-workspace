CREATE VIEW dbo.USER_ORGANIZATIONS_V
AS
SELECT     dbo.USER_ORGANIZATIONS.ORGANIZATION_ID, dbo.USERS.USER_ID, dbo.USERS.EXT_EMPLOYEE_ID, dbo.USERS.CONTACT_ID, 
                      dbo.USERS.EMPLOYMENT_TYPE_ID, dbo.USERS.EXT_DEALER_ID, dbo.USERS.DEALER_NAME, dbo.USERS.USER_TYPE_ID, 
                      dbo.USERS.FIRST_NAME, dbo.USERS.LAST_NAME, dbo.USERS.LOGIN, dbo.USERS.PASSWORD, dbo.USERS.LAST_LOGIN, dbo.USERS.PIN, 
                      dbo.USERS.ACTIVE_FLAG, dbo.USERS.IMOBILE_LOGIN, dbo.USERS.LAST_SYNCH_DATE, dbo.USERS.DATE_CREATED, dbo.USERS.CREATED_BY, 
                      dbo.USERS.DATE_MODIFIED, dbo.USERS.MODIFIED_BY, dbo.USER_ORGANIZATIONS.DATE_CREATED AS user_org_date_created, 
                      dbo.USER_ORGANIZATIONS.CREATED_BY AS user_org_created_by, dbo.USER_ORGANIZATIONS.DATE_MODIFIED AS user_org_date_modified, 
                      dbo.USER_ORGANIZATIONS.MODIFIED_BY AS user_org_modified_by
FROM         dbo.USERS LEFT OUTER JOIN
                      dbo.USER_ORGANIZATIONS ON dbo.USERS.USER_ID = dbo.USER_ORGANIZATIONS.USER_ID


