
CREATE VIEW dbo.USER_ROLES_V
AS
SELECT     dbo.USER_ROLES.USER_ID, dbo.USER_ROLES.ROLE_ID, dbo.ROLES.NAME AS role_name, dbo.ROLES.CODE AS role_code, 
                      dbo.USER_ROLES.DATE_CREATED, dbo.USER_ROLES.CREATED_BY, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, 
                      dbo.USER_ROLES.DATE_MODIFIED, dbo.USER_ROLES.MODIFIED_BY, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.USER_ROLES INNER JOIN
                      dbo.ROLES ON dbo.USER_ROLES.ROLE_ID = dbo.ROLES.ROLE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.USER_ROLES.MODIFIED_BY = USERS_2.USER_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.USER_ROLES.CREATED_BY = USERS_1.USER_ID



