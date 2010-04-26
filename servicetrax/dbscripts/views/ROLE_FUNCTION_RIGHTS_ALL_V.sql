CREATE VIEW dbo.ROLE_FUNCTION_RIGHTS_ALL_V
AS
SELECT     dbo.ROLE_FUNCTIONS_ALL_V.ROLE_ID, dbo.ROLE_FUNCTIONS_ALL_V.role_name, dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_name, dbo.ROLE_FUNCTIONS_ALL_V.function_code, dbo.ROLE_FUNCTIONS_ALL_V.function_desc, 
                      dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_GROUP_ID, dbo.ROLE_FUNCTIONS_ALL_V.function_group_code, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_group_name, dbo.ROLE_FUNCTIONS_ALL_V.TEMPLATE_ID, dbo.ROLE_FUNCTIONS_ALL_V.SEQUENCE_NO, 
                      dbo.ROLE_FUNCTIONS_ALL_V.IS_NAV_FUNCTION, dbo.ROLE_FUNCTIONS_ALL_V.IS_MENU_FUNCTION, dbo.ROLE_FUNCTIONS_ALL_V.TARGET, 
                      dbo.ROLE_FUNCTION_RIGHTS.ROLE_FUNCTION_RIGHT_ID, dbo.RIGHT_TYPES.RIGHT_TYPE_ID, dbo.RIGHT_TYPES.CODE AS right_type_code, 
                      dbo.RIGHT_TYPES.NAME AS right_type_name, dbo.RIGHT_TYPES.DESCRIPTION AS right_type_desc, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_date_created, dbo.ROLE_FUNCTIONS_ALL_V.function_created_by, 
                      dbo.ROLE_FUNCTIONS_ALL_V.function_date_modified, dbo.ROLE_FUNCTIONS_ALL_V.function_modified_by, 
                      dbo.FUNCTION_RIGHT_TYPES.UPDATABLE_FLAG AS right_updatable_flag, dbo.ROLE_FUNCTIONS_ALL_V.LOCATION, 
                      (CASE ISNULL(dbo.ROLE_FUNCTION_RIGHTS.ROLE_FUNCTION_RIGHT_ID, - 1) WHEN - 1 THEN 'N' ELSE 'Y' END) has_right
FROM         dbo.FUNCTION_RIGHT_TYPES INNER JOIN
                      dbo.ROLE_FUNCTIONS_ALL_V ON dbo.FUNCTION_RIGHT_TYPES.FUNCTION_ID = dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID LEFT OUTER JOIN
                      dbo.ROLE_FUNCTION_RIGHTS ON dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID = dbo.ROLE_FUNCTION_RIGHTS.RIGHT_TYPE_ID AND 
                      dbo.ROLE_FUNCTIONS_ALL_V.FUNCTION_ID = dbo.ROLE_FUNCTION_RIGHTS.FUNCTION_ID AND 
                      dbo.ROLE_FUNCTIONS_ALL_V.ROLE_ID = dbo.ROLE_FUNCTION_RIGHTS.ROLE_ID RIGHT OUTER JOIN
                      dbo.RIGHT_TYPES ON dbo.FUNCTION_RIGHT_TYPES.RIGHT_TYPE_ID = dbo.RIGHT_TYPES.RIGHT_TYPE_ID

