CREATE VIEW dbo.RESOURCE_TYPES_V
AS
SELECT     dbo.RESOURCE_TYPES.RESOURCE_TYPE_ID, dbo.RESOURCE_TYPES.NAME AS resource_type_name, 
                      dbo.RESOURCE_TYPES.CODE AS resource_type_code, dbo.RESOURCE_TYPES.SEQUENCE_NO, dbo.RESOURCE_TYPES.DEF_TIME_UOM_TYPE_ID, 
                      LOOKUPS_2.CODE AS def_time_uom_type_code, LOOKUPS_2.NAME AS def_time_uom_type_name, dbo.RESOURCE_TYPES.DEF_RES_CAT_TYPE_ID, 
                      LOOKUPS_1.CODE AS def_res_cat_type_code, LOOKUPS_1.NAME AS def_res_cat_type_name, dbo.RESOURCE_TYPES.ESTIMATE_HOURS_FLAG, 
                      dbo.RESOURCE_TYPES.UNIQUE_FLAG, dbo.RESOURCE_TYPES.DATE_CREATED, dbo.RESOURCE_TYPES.CREATED_BY, 
                      USERS_1.FIRST_NAME + ' ' + USERS_1.LAST_NAME AS created_by_name, dbo.RESOURCE_TYPES.DATE_MODIFIED, 
                      dbo.RESOURCE_TYPES.MODIFIED_BY, USERS_2.FIRST_NAME + ' ' + USERS_2.LAST_NAME AS modified_by_name
FROM         dbo.USERS USERS_1 RIGHT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_1 RIGHT OUTER JOIN
                      dbo.RESOURCE_TYPES ON LOOKUPS_1.LOOKUP_ID = dbo.RESOURCE_TYPES.DEF_RES_CAT_TYPE_ID LEFT OUTER JOIN
                      dbo.USERS USERS_2 ON dbo.RESOURCE_TYPES.MODIFIED_BY = USERS_2.USER_ID ON 
                      USERS_1.USER_ID = dbo.RESOURCE_TYPES.CREATED_BY LEFT OUTER JOIN
                      dbo.LOOKUPS LOOKUPS_2 ON dbo.RESOURCE_TYPES.DEF_TIME_UOM_TYPE_ID = LOOKUPS_2.LOOKUP_ID

