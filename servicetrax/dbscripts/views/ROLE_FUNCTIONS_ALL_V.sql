CREATE VIEW dbo.ROLE_FUNCTIONS_ALL_V
AS
SELECT     dbo.ROLES.ROLE_ID, dbo.ROLES.NAME AS role_name, dbo.FUNCTIONS.FUNCTION_ID, dbo.FUNCTIONS.NAME AS function_name, 
                      dbo.FUNCTIONS.CODE AS function_code, dbo.FUNCTIONS.DESCRIPTION AS function_desc, dbo.FUNCTIONS.FUNCTION_GROUP_ID, 
                      dbo.FUNCTION_GROUPS.CODE AS function_group_code, dbo.FUNCTION_GROUPS.NAME AS function_group_name, dbo.FUNCTIONS.TEMPLATE_ID, 
                      dbo.FUNCTIONS.SEQUENCE_NO, dbo.FUNCTIONS.IS_NAV_FUNCTION, dbo.FUNCTIONS.IS_MENU_FUNCTION, dbo.FUNCTIONS.TARGET, 
                      dbo.FUNCTIONS.DATE_CREATED AS function_date_created, dbo.FUNCTIONS.CREATED_BY AS function_created_by, 
                      dbo.FUNCTIONS.DATE_MODIFIED AS function_date_modified, dbo.FUNCTIONS.MODIFIED_BY AS function_modified_by, 
                      dbo.FUNCTIONS.TEMPLATE_LOCATION_ID, dbo.TEMPLATE_LOCATIONS.LOCATION
FROM         dbo.TEMPLATE_LOCATIONS RIGHT OUTER JOIN
                      dbo.FUNCTIONS ON dbo.TEMPLATE_LOCATIONS.TEMPLATE_LOCATION_ID = dbo.FUNCTIONS.TEMPLATE_LOCATION_ID LEFT OUTER JOIN
                      dbo.FUNCTION_GROUPS ON dbo.FUNCTIONS.FUNCTION_GROUP_ID = dbo.FUNCTION_GROUPS.FUNCTION_GROUP_ID CROSS JOIN
                      dbo.ROLES

