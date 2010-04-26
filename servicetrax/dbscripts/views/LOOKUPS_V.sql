CREATE VIEW dbo.LOOKUPS_V
AS
SELECT     TOP 100 PERCENT dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID, dbo.LOOKUP_TYPES.CODE AS type_code, dbo.LOOKUP_TYPES.NAME AS type_name, 
                      dbo.LOOKUP_TYPES.ACTIVE_FLAG AS type_active_flag, dbo.LOOKUP_TYPES.UPDATABLE_FLAG AS type_updatable_flag, 
                      dbo.LOOKUP_TYPES.PARENT_TYPE_ID, dbo.LOOKUP_TYPES.DATE_CREATED AS type_date_created, 
                      dbo.LOOKUP_TYPES.CREATED_BY AS type_created_by, USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS type_created_by_name, 
                      dbo.LOOKUP_TYPES.DATE_MODIFIED AS type_date_modified, dbo.LOOKUP_TYPES.MODIFIED_BY AS type_modified_by, 
                      USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS type_modified_by_name, dbo.LOOKUPS.LOOKUP_ID, dbo.LOOKUPS.CODE AS lookup_code, 
                      dbo.LOOKUPS.NAME AS lookup_name, dbo.LOOKUPS.SEQUENCE_NO, dbo.LOOKUPS.ACTIVE_FLAG AS lookup_active_flag, 
                      dbo.LOOKUPS.UPDATABLE_FLAG AS lookup_updatable_flag, dbo.LOOKUPS.PARENT_LOOKUP_ID, dbo.LOOKUPS.EXT_ID, dbo.LOOKUPS.ATTRIBUTE1,
                       dbo.LOOKUPS.ATTRIBUTE2, dbo.LOOKUPS.ATTRIBUTE3, dbo.LOOKUPS.DATE_CREATED AS lookup_date_created, 
                      dbo.LOOKUPS.CREATED_BY AS lookup_created_by, USERS_3.FIRST_NAME + ' ' + USERS_3.LAST_NAME AS lookup_created_by_name, 
                      dbo.LOOKUPS.DATE_MODIFIED AS lookup_date_modified, dbo.LOOKUPS.MODIFIED_BY AS lookup_modified_by, 
                      USERS_4.FIRST_NAME + ' ' + USERS_4.LAST_NAME AS lookup_modified_by_name
FROM         dbo.USERS USERS_4 RIGHT OUTER JOIN
                      dbo.LOOKUPS ON USERS_4.USER_ID = dbo.LOOKUPS.MODIFIED_BY LEFT OUTER JOIN
                      dbo.USERS USERS_3 ON dbo.LOOKUPS.CREATED_BY = USERS_3.USER_ID RIGHT OUTER JOIN
                      dbo.USERS USERS_2 RIGHT OUTER JOIN
                      dbo.LOOKUP_TYPES ON USERS_2.USER_ID = dbo.LOOKUP_TYPES.MODIFIED_BY ON 
                      dbo.LOOKUPS.LOOKUP_TYPE_ID = dbo.LOOKUP_TYPES.LOOKUP_TYPE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_1 ON dbo.LOOKUP_TYPES.CREATED_BY = USERS_1.USER_ID
ORDER BY type_code, dbo.LOOKUPS.SEQUENCE_NO

