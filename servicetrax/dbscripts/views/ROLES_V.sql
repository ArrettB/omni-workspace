
CREATE VIEW dbo.ROLES_V
AS
SELECT     C_USER.FIRST_NAME + ' ' + C_USER.LAST_NAME AS created_by_name, M_USER.FIRST_NAME + ' ' + M_USER.LAST_NAME AS modified_by_name, 
                      dbo.ROLES.*
FROM         dbo.ROLES LEFT OUTER JOIN
                      dbo.USERS C_USER ON dbo.ROLES.CREATED_BY = C_USER.USER_ID LEFT OUTER JOIN
                      dbo.USERS M_USER ON dbo.ROLES.MODIFIED_BY = M_USER.USER_ID


