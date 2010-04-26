CREATE VIEW dbo.USER_FUNCTION_RIGHTS_V
AS
SELECT     dbo.USERS.USER_ID, dbo.USERS.FIRST_NAME + ' ' + dbo.USERS.LAST_NAME AS user_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.role_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_desc, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.FUNCTION_GROUP_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_code, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_group_name, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.SEQUENCE_NO, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_NAV_FUNCTION, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.IS_MENU_FUNCTION, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TARGET, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_FUNCTION_RIGHT_ID, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.RIGHT_TYPE_ID, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_code, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_name, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_type_desc, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_created, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_created_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_date_modified, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.function_modified_by, 
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V.right_updatable_flag, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.has_right, 
                      dbo.USERS.ACTIVE_FLAG AS user_active_flag, TEMPLATES_1.TEMPLATE_NAME, dbo.ROLE_FUNCTION_RIGHTS_ALL_V.LOCATION
FROM         dbo.TEMPLATES TEMPLATES_1 RIGHT OUTER JOIN
                      dbo.ROLE_FUNCTION_RIGHTS_ALL_V RIGHT OUTER JOIN
                      dbo.USER_ROLES ON dbo.ROLE_FUNCTION_RIGHTS_ALL_V.ROLE_ID = dbo.USER_ROLES.ROLE_ID RIGHT OUTER JOIN
                      dbo.USERS ON dbo.USER_ROLES.USER_ID = dbo.USERS.USER_ID ON 
                      TEMPLATES_1.TEMPLATE_ID = dbo.ROLE_FUNCTION_RIGHTS_ALL_V.TEMPLATE_ID
WHERE     (dbo.USERS.ACTIVE_FLAG = 'Y')


