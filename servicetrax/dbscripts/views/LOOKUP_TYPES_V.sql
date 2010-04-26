CREATE VIEW dbo.LOOKUP_TYPES_V
AS
SELECT     dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID, dbo.LOOKUP_TYPES.CODE AS type_code, dbo.LOOKUP_TYPES.NAME AS type_name, 
                      dbo.LOOKUP_TYPES.ACTIVE_FLAG, dbo.LOOKUP_TYPES.UPDATABLE_FLAG, dbo.LOOKUP_TYPES.PARENT_TYPE_ID, 
                      dbo.LOOKUP_TYPES.DATE_CREATED AS type_date_created, dbo.LOOKUP_TYPES.CREATED_BY AS type_created_by, 
                      created_by_name.FIRST_NAME + ' ' + created_by_name.LAST_NAME AS type_created_by_name, 
                      dbo.LOOKUP_TYPES.DATE_MODIFIED AS type_date_modified, dbo.LOOKUP_TYPES.MODIFIED_BY AS type_modified_by, 
                      modified_by_name.FIRST_NAME + ' ' + modified_by_name.LAST_NAME AS type_modified_by_name
FROM         dbo.LOOKUP_TYPES LEFT OUTER JOIN
                      dbo.USERS modified_by_name ON dbo.LOOKUP_TYPES.MODIFIED_BY = modified_by_name.USER_ID LEFT OUTER JOIN
                      dbo.USERS created_by_name ON dbo.LOOKUP_TYPES.CREATED_BY = created_by_name.USER_ID

